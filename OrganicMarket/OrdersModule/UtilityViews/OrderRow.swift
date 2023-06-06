import SwiftUI

struct OrderRow: View {
    var order: Order
    var farmerInitiated: Bool
    var body: some View {
            VStack {
                HStack {
                    Text("Заказ #\(order.id)")
                        .padding()
                    
                    Spacer()
                    
                    Text("\(totalSum()) руб.")
                        .font(.caption)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                        .background {
                            Color.red
                        }.clipShape(Capsule())
                        .padding()
                }
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(order.products, id: \.self) { product in
                            let num = order.products.reduce(into: [:]) { counts, id in
                                counts[id, default: 0] += 1
                            }
                            NavigationLink(destination: ProductView(product: product, farmerInitiated: farmerInitiated, viewModel: .init(productId: product.id))) {
                                ProductCell(product: product, num: num[product])
                                    .frame(minWidth: 170, maxWidth: 170, minHeight: 200, maxHeight: 300)
                                    .background {
                                        Color(.white)
                                    }
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.3), radius: 3)
                                    .padding()
                            }.tint(.black)
                        }
                    }
                }.scrollIndicators(.hidden)
            }
    }
    
    func totalSum() -> NSString {
        var sum: Double = 0
        for product in order.products {
            sum += product.price
        }
        if modf(sum).1 > 0 {
            return NSString(string: String(sum))
        }
        else {
            return NSString(format: "%.0f", sum)
        }
    }
}

struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: .init(id: 0, userId: 0, userName: "Test User", products: [seedProduct, seedProduct]), farmerInitiated: false)
    }
}
