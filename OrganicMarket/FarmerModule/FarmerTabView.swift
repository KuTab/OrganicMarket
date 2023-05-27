import SwiftUI

struct FarmerTabView: View {
    var body: some View {
        TabView {
            FarmerView()
                .tabItem {
                    VStack {
                        Image(systemName: "cart")
                        Text("Мои продукты")
                    }
                }
            
            OrdersView(ownerRole: .supplier)
                .tabItem {
                    VStack {
                        Image(systemName: "bag.fill")
                        Text("Заказы")
                    }
                }
            
            FarmerChatListView()
                .tabItem {
                    VStack {
                        Image(systemName: "message.fill")
                        Text("чаты")
                    }
                }
            
            UserView()
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Профиль")
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

struct FarmerTabView_Previews: PreviewProvider {
    static var previews: some View {
        FarmerTabView()
    }
}
