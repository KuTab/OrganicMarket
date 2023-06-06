import SwiftUI

enum Roles {
    case user
    case supplier
}

struct OrdersView: View {
    @StateObject var viewModel: OrdersViewViewModel = .init()
    var ownerRole: Roles
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Мои заказы")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.horizontal, 20)
                    
                    LazyVStack {
                        ForEach(viewModel.orders, id: \.self) { order in
                            if(ownerRole == .supplier) {
                                VStack(alignment: .center) {
                                    OrderRow(order: order, farmerInitiated: true)
                                        .frame(maxWidth:.infinity, minHeight: 200, maxHeight: .infinity)
                                        .padding()
                                    NavigationLink(destination: ChatView(messagesManager: .init(senderId: order.userId, chatId: nil), name: order.userName)){
                                        HStack {
                                            Image(systemName: "message.fill")
                                                .foregroundColor(.white)
                                                .frame(width: 40, height: 40)
                                                .padding()
                                            Text("Чат с покупателем")
                                            .foregroundColor(.white)
                                            .padding()
                                        }.frame(maxWidth: .infinity, minHeight: 50)
                                            .background(.green)
                                            .clipShape(Capsule())
                                            .padding()
                                    }.tint(.black)
                                }
                            } else {
                                OrderRow(order: order, farmerInitiated: false)
                                    .frame(maxWidth:.infinity, minHeight: 200, maxHeight: .infinity)
                                    .padding()
                            }
                            
                            Divider()
                        }
                    }
                }
            }.scrollIndicators(.hidden)
            .onAppear {
                switch ownerRole {
                case .user:
                    viewModel.fetchUserOrders()
                case .supplier:
                    viewModel.fetchSupplierOrders()
                }
            }
        }.toolbar(.hidden)
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(ownerRole: .user)
    }
}
