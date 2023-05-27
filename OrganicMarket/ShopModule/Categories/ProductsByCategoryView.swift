import SwiftUI
import Combine

struct ProductsByCategoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: ProductByCategoryViewViewModel = .init()
    var category: String
    var cartObserver: PassthroughSubject<Product, Never>
    var differenceObserver: PassthroughSubject<Product, Never>
    @State var searchingText: String = ""
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading) {
                    Text("Продукты")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.horizontal, 80)
                        .padding(.vertical, 20)
                    TextField("Поиск",text: $searchingText)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding(.horizontal)
                        .background(.gray.opacity(0.2))
                        .clipShape(Capsule())
                        .padding()
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.products.filter {$0.title.hasPrefix(searchingText) || searchingText == ""}, id: \.self) { product in
                                NavigationLink(destination: ProductView(product: product, viewModel: .init(productId: product.id))) {
                                    ProductCell(product: product, sender: cartObserver, differenceSender: differenceObserver)
                                        .frame(minWidth: 170, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                                        .background(.white)
                                        .cornerRadius(20)
                                        .shadow(color: .black.opacity(0.3), radius: 3)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 10)
                                }.foregroundColor(.black)
                            }
                        }.padding(.leading, 10)
                            .padding(.trailing, 10)
                    }.scrollIndicators(.hidden)
                        .onAppear {
                            viewModel.fetchProductByCategory(category: category)
                        }
                }
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .frame(minWidth: 50, minHeight: 50)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 1)
                }
                .padding()
            }
        }.accentColor(.white)
            .toolbar(.hidden, for: .navigationBar)
    }
}

struct ProductsByCategoryView_Previews: PreviewProvider {
    static var cartObserver: PassthroughSubject<Product, Never> = .init()
    static var differenceObserver: PassthroughSubject<Product, Never> = .init()
    static var previews: some View {
        ProductsByCategoryView(category: "Фрукты", cartObserver: cartObserver, differenceObserver: differenceObserver)
    }
}
