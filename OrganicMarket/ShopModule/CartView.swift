import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: ShopViewModel
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Корзина")
                .font(.system(size: 30))
                .bold()
                .padding(.horizontal, 20)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.cart, id: \.self.num) { product in
                        ProductCell(product: product.product, eraser: viewModel.cartEraser, deleting: true, num: product.num)
                            .frame(minWidth: 170, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                            .background(.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.3), radius: 3)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                    }
                }.padding(.leading, 10)
                    .padding(.trailing, 10)
            }.scrollIndicators(.hidden)
            Button {
                viewModel.createOrder()
            } label: {
                Text("Оформить заказ")
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                .background(.green)
                .clipShape(Capsule())
                .padding()
                .font(.system(size: 20))
                .bold()
                .foregroundColor(.white)
            }.disabled(viewModel.cart.isEmpty)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var viewModel = ShopViewModel()
    static var previews: some View {
        CartView(viewModel: viewModel)
    }
}
