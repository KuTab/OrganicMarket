import SwiftUI

struct UserEditingView: View {
    @StateObject var viewModel: UserEditingViewModel
    @Binding var isShowed: Bool
    var body: some View {
        ScrollView {
            VStack {
                Text("\(viewModel.user.name) \(viewModel.user.surname)")
                    .font(.system(size: 28))
                    .bold()
                    .padding()
                Text("Электронная почта:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                
                TextField("Email", text: $viewModel.user.email)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Divider()
                
                Text("Телефон:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                
                TextField("Phone", text: $viewModel.user.phone)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Divider()
                
                Text("Адрес:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                
                TextEditor(text: $viewModel.user.address)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .shadow(radius: 0.5)
                    .padding()
                
                Button {
                    viewModel.saveUpdates()
                    isShowed = false
                } label: {
                    Text("Обновить профиль")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(.green)
                        .clipShape(Capsule())
                        .padding()
                }

            }
        }
    }
}

struct UserEditingView_Previews: PreviewProvider {
    @StateObject static var viewModel: UserEditingViewModel = .init(user: seedUser)
    @State static var isShowed: Bool = true
    static var previews: some View {
        UserEditingView(viewModel: viewModel, isShowed: $isShowed)
    }
}
