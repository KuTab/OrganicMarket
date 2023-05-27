import SwiftUI
import Combine

struct AddProductView: View {
    @Binding var isShowed: Bool
    var updatePublisher: PassthroughSubject<Void, Never>?
    @ObservedObject var viewModel = AddProductViewModel()
    var body: some View {
        VStack(alignment: .leading) {
                Text("Продать продукт")
                    .font(.system(size: 24))
                    .bold()
                    .padding()
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Название")
                    TextField("Название", text: $viewModel.title)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Цена")
                    TextField("Цена", value: $viewModel.price, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Вес")
                    TextField("Вес", value: $viewModel.weight, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Описание")
                    TextEditor(text: $viewModel.description)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .shadow(radius: 0.5)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Категория")
                    TextField("Категроия", text: $viewModel.category)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Состав")
                    TextEditor( text: $viewModel.composition)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .shadow(radius: 0.5)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Срок годности")
                    TextField("Срок годности", text: $viewModel.expiration)
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Условия хранения")
                    TextEditor(text: $viewModel.storageCondition)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .shadow(radius: 0.5)
                }.padding()
            }
            
            Button {
                viewModel.addProduct(updatePublisher: updatePublisher ?? .init())
                isShowed.toggle()
            } label: {
                Text("Создать")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(.green)
                    .clipShape(Capsule())
                    .padding()
            }
        }

    }
}

struct AddProductView_Previews: PreviewProvider {
    @State static var flag: Bool = true
    static var previews: some View {
        AddProductView(isShowed: $flag)
    }
}
