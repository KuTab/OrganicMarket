import SwiftUI
import Combine
import PhotosUI

struct AddProductView: View {
    @Binding var isShowed: Bool
    var updatePublisher: PassthroughSubject<Void, Never>?
    @ObservedObject var viewModel = AddProductViewModel()
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
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
                    Text("Вес/Объем")
                    HStack {
                        TextField("Вес/Объем", value: $viewModel.weight, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        
                        Picker("", selection: $viewModel.metric) {
                            ForEach(viewModel.metrics, id: \.self) { metric in
                                Text(metric)
                            }
                        }
                    }
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Количество")
                    TextField("Количество", value: $viewModel.quantity, format: .number)
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
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Text(category)
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 40)
                                    .background {
                                        viewModel.category == category ? Color.green : Color.gray.opacity(0.65)
                                    }.clipShape(Capsule())
                                    .padding(.horizontal, 1)
                                    .padding(.vertical, 2)
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.category = category
                                        }
                                    }
                            }
                        }
                    }.scrollIndicators(.hidden)
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Состав")
                    TextEditor( text: $viewModel.composition)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .shadow(radius: 0.5)
                }.padding()
                
                VStack(alignment: .leading) {
                    DatePicker(selection: $viewModel.expirationDate, displayedComponents: .date) {
                        Text("Cрок годности")
                    }.pickerStyle(.menu)
                        .environment(\.locale, Locale.init(identifier: "ru"))
                }.padding()
                
                VStack(alignment: .leading) {
                    Text("Условия хранения")
                    TextEditor(text: $viewModel.storageCondition)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .shadow(radius: 0.5)
                }.padding()
                
                PhotosPicker(selection: $viewModel.photoItem) {
                    Text("Приложите фото")
                }
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
            }.disabled(viewModel.title.isEmpty || viewModel.price <= 0 || viewModel.weight <= 0 || viewModel.description.isEmpty || viewModel.category.isEmpty || viewModel.quantity <= 0 || viewModel.storageCondition.isEmpty || viewModel.composition.isEmpty)
        }
        .onAppear {
            viewModel.fetchCategories()
        }
        .onChange(of: viewModel.photoItem) { newItem in
            Task {
                if let data = try await newItem?.loadTransferable(type: Data.self) {
                    viewModel.photo = data.base64EncodedString()
                    print("Photo \(viewModel.photo)")
                }
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
