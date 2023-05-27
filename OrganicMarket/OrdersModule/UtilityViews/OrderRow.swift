import SwiftUI

struct OrderRow: View {
    var order: Order
    var body: some View {
        VStack {
            Text("Заказ #\(order.id)")
                .padding()
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(order.products, id: \.self) { product in
                        ProductCell(product: product)
                            .frame(minWidth: 170, maxWidth: 170, minHeight: 200, maxHeight: 300)
                            .background {
                                Color(.white)
                            }
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.3), radius: 3)
                            .padding()
                    }
                }
            }.scrollIndicators(.hidden)
        }
    }
}

struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: .init(id: 0, userId: 0, userName: "Test User", products: [seedProduct]))
    }
}
