import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = LoginViewModel()
    var body: some View {
        if !viewModel.registered {
            RegistrationView(viewModel: viewModel)
        } else if !viewModel.loggedIn {
            LoginView(viewModel: viewModel)
        } else {
            ZStack(alignment: .topTrailing) {
                switch viewModel.isSupplier {
                case false:
                    ShopTabView()
                case true:
                    FarmerTabView()
                }
//                Button {
//                    //viewModel.registered = false
//                    viewModel.loggedIn = false
//                } label: {
//                    Image(systemName: "arrowshape.turn.up.backward.fill")
//                        .foregroundColor(.white)
//                        .frame(minWidth: 50, minHeight: 50)
//                        .background(.red)
//                        .clipShape(Circle())
//                }
//                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
