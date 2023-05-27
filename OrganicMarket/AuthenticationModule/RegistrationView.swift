import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack{
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
            
            VStack(alignment: .leading){
                Text("Имя")
                SecureField("Имя", text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
            }.padding()
            
            VStack(alignment: .leading){
                Text("Фамилия")
                SecureField("Фамилия", text: $viewModel.surname)
                    .textFieldStyle(.roundedBorder)
            }.padding()
            
            HStack(alignment: .center){
                Text("Я фермер")
                CheckBoxView(isOn: $viewModel.isSupplier)
            }.padding()
            
            Text("Уже есть профиль? Войти").onTapGesture {
                viewModel.registered = true
                viewModel.loggedIn = false
            }
            
            Button {
                viewModel.register()
            } label: {
                Text("Зарегистрироваться")
            }.buttonStyle(.borderedProminent)
        }.alert(isPresented: $viewModel.showAllert) {
            Alert(title: Text("Ошибка"), message: Text(viewModel.message), dismissButton: .default(Text("Ок")))
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: LoginViewModel())
    }
}
