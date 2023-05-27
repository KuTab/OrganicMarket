import SwiftUI

struct ShopView: View {
    @ObservedObject var viewModel: ShopViewModel
    @State var searchingText: String = ""
    @State var isShowingDetail: Bool = false
    @State var selectedProduct: Product?
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView {
            //            VStack(alignment: .leading) {
            //                Text("Продукты")
            //                    .font(.system(size: 30))
            //                    .bold()
            //                    .padding(.horizontal, 20)
            //                TextField("Поиск",text: $searchingText)
            //                    .frame(maxWidth: .infinity, maxHeight: 40)
            //                    .padding(.horizontal)
            //                    .background(.gray.opacity(0.2))
            //                    .clipShape(Capsule())
            //                    .padding()
            //                ScrollView {
            //                    LazyVGrid(columns: columns) {
            //                        ForEach(viewModel.products.filter {$0.title.hasPrefix(searchingText) || searchingText == ""}, id: \.self) { product in
            //                            NavigationLink(destination: ProductView(product: product, viewModel: .init(productId: product.id))) {
            //                                ProductCell(product: product, sender: viewModel.cartObserver)
            //                                    .frame(minWidth: 170, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            //                                    .background(.gray.opacity(0.2))
            //                                    .cornerRadius(20)
            //                                    .padding(.horizontal, 10)
            //                                    .padding(.vertical, 10)
            //                            }.foregroundColor(.black)
            //                        }
            //                    }.padding(.leading, 10)
            //                        .padding(.trailing, 10)
            //                }.scrollIndicators(.hidden)
            //                    .onAppear {
            //                        viewModel.fetchProducts()
            //                    }
            //            }
            VStack {
                CategoriesView(cartObserver: viewModel.cartObserver, differenceObserver: viewModel.differenceObserver)
            }
        }.accentColor(.white)
            .toolbar(.hidden)
    }
}

struct ShopView_Previews: PreviewProvider {
    static var viewModel = ShopViewModel()
    static var previews: some View {
        ShopView(viewModel: viewModel)
    }
}
