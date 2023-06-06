import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                Text("Электронная почта")
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
            }.padding()
            
            VStack(alignment: .leading){
                Text("Пароль")
                SecureField("Пароль", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
            }.padding()
            
            Text("Нет профиля? Регистрация")
                .foregroundColor(.blue)
                .onTapGesture {
                viewModel.registered = false
            }
            
            Button {
                viewModel.login()
            } label: {
                Text("Войти")
            }.disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
            .buttonStyle(.borderedProminent)

        }.alert(isPresented: $viewModel.showAllert) {
            Alert(title: Text("Ошибка"), message: Text(viewModel.message), dismissButton: .default(Text("Ок")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
