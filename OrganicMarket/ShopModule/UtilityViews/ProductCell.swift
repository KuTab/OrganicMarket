import SwiftUI
import Combine

struct ProductCell: View {
    var product: Product
    var sender: PassthroughSubject<Product, Never>?
    var eraser: PassthroughSubject<Int, Never>?
    var differenceSender: PassthroughSubject<Product, Never>?
    var adder: PassthroughSubject<Int, Never>?
    var deleting = false
    var num: Int?
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image("OrganicImage")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                
                if let sender = differenceSender {
                    Button {
                        sender.send(product)
                    } label: {
                        Image(systemName: "list.clipboard.fill")
                            .foregroundColor(.gray)
                            .frame(minWidth: 30, minHeight: 30)
                            .background(.white)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(product.title)
                        .font(.system(size: 18))
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                
                Text("От: \(product.supplier.name) \(product.supplier.surname)")
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
            }
            
            HStack {
                Text("\(formatPrice(price: product.price)) руб.")
                    .font(.caption)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
                    .background {
                        Color.red
                    }.clipShape(Capsule())
                    
                Spacer()
                
                if let sender = sender {
                    Button {
                        sender.send(product)
                    } label: {
                        Image(systemName: "cart.fill")
                            .foregroundColor(.white)
                            .frame(minWidth: 40, minHeight: 40)
                            .background(.gray)
                            .clipShape(Circle())
                    }
                }
                
                if let eraser = eraser {
                    Button {
                        eraser.send(num!)
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                            .frame(minWidth: 40, minHeight: 40)
                            .background(.red)
                            .clipShape(Circle())
                    }
                }
                
                if let adder = adder {
                    Button {
                        adder.send(1)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(minWidth: 40, minHeight: 40)
                            .background(.green)
                            .clipShape(Circle())
                    }
                }
            }.padding(.horizontal)
                .padding(.vertical)
            
        }
    }
    
    private func formatPrice(price: Double) -> NSString {
        if modf(price).1 > 0 {
            return NSString(string: String(price))
        }
        else {
            return NSString(format: "%.0f", price)
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var sender: PassthroughSubject<Product, Never> = .init()
    static var differenceSender: PassthroughSubject<Product, Never> = .init()
    static var previews: some View {
        ProductCell(product: seedProduct, sender: sender, differenceSender: differenceSender)
    }
}
