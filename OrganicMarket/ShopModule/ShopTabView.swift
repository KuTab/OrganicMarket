import SwiftUI

struct ShopTabView: View {
    @ObservedObject var viewModel = ShopViewModel()
    var body: some View {
        TabView {
            ShopView(viewModel: viewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "plus")
                        Text("Каталог")
                    }
            }
            
            CartView(viewModel: viewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "cart")
                        Text("Корзина")
                    }
            }
            
            OrdersView(ownerRole: .user)
                .tabItem {
                    VStack {
                        Image(systemName: "bag.fill")
                        Text("Заказы")
                    }
                }
            
            DifferenceView(viewModel: viewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "list.clipboard.fill")
                        Text("Сравнение")
                    }
                }
            
            UserChatListView()
                .tabItem {
                    VStack {
                        Image(systemName: "message.fill")
                        Text("Чаты")
                    }
                }
        }.onAppear {
            if #available(iOS 13.0, *) {
                let tabBarApperance: UITabBarAppearance = UITabBarAppearance()
                tabBarApperance.configureWithDefaultBackground()
                tabBarApperance.backgroundColor = UIColor.systemBackground
                UITabBar.appearance().standardAppearance = tabBarApperance
                
                if #available(iOS 15.0, *) {
                    UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
                }
            }
        }
    }
}

struct ShopTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShopTabView()
    }
}
