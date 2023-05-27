import SwiftUI

//MARK: - Enum для Picker
enum ProductTabs: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case info = "Описание"
    case characteristics = "Характеристики"
    case feedback = "Отзывы"
}

struct ProductView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selection = ProductTabs.info
    @State var feedbackIsShowed = false
    @State var product: Product
    var farmerInitiated = false
    @StateObject var viewModel: ProductViewViewModel
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                ScrollView(.vertical) {
                    StickyHeader {
                        Color(.red)
                    }
                    
                    VStack {
                        //MARK: - Верхнее View
                        HStack {
                            Text(product.title)
                                .font(.system(size: 24))
                                .bold()
                                .padding()
                            Spacer()
                            
                            Text(String(product.price) + " руб.")
                                .padding()
                        }
                        
                        //MARK: - View Рейтинга
                        HStack {
                            OneStarView(rating: product.rating)
                            Text(String(product.rating))
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.gray)
                        }.frame(maxWidth: .infinity, minHeight:  65)
                            .background {
                                Color(.white)
                            }
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.3), radius: 8)
                            .padding()
                        
                        //MARK: - Picker View
                        Picker("Tabs", selection: $selection) {
                            ForEach(ProductTabs.allCases) { tab in
                                Text(tab.rawValue).tag(tab)
                            }
                        }.pickerStyle(.segmented)
                            .padding()
                        
                        //MARK: - Switch для отображение информации
                        switch selection {
                            //MARK: - View общей информации
                        case .info:
                            Text("Описание:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            Text(product.description)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            if(!farmerInitiated) {
                                NavigationLink(destination: SupplierView(user: product.supplier, viewModel: .init(supplierId: product.supplier.id))) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.black)
                                        .padding()
                                    Spacer()
                                    Text("\(product.supplier.name) \(product.supplier.surname)")
                                        .font(.system(size: 24))
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding()
                                    Spacer()
                                }.frame(maxWidth: .infinity, minHeight:  65)
                                    .background {
                                        Color(.white)
                                    }
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.3), radius: 8)
                                    .padding()
                            }
                        }
                            //MARK: - View характеристик
                        case .characteristics:
                            Group {
                                Text("Состав:")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                Text(product.composition)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                Divider()
                                
                                Text("Вес:")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                Text(String(product.weight) + "г.")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                Divider()
                            }
                            
                            Group {
                                
                                Text("Условия хранения:")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                Text(product.storageCondition)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                Divider()
                                
                                Text("Срок годности:")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                Text(product.expiration)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                            }
                            
                            
                            //MARK: - View отзывов
                        case .feedback:
                            Text("Отзывы")
                            ForEach(viewModel.productFeedbacks, id: \.self) { feedback in
                                VStack(alignment: .leading) {
                                    HStack {
                                        FiveStarInfoView(rating: feedback.rate)
                                            .padding()
                                        Text(formatTimeStamp(date: feedback.timeStamp))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    }
                                    HStack {
                                        Text(feedback.feedback)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    }
                                }.frame(minHeight: 65)
                                    .background {
                                        Color(.white)
                                    }
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.3), radius: 8)
                                    .padding()
                            }
                            if(!farmerInitiated) {
                                Button {
                                    feedbackIsShowed = true
                                } label: {
                                    Text("Оставить отзыв")
                                }.buttonStyle(.bordered)
                            }
                        }
                        
                    }.frame(maxWidth: .infinity)
                        .background(content: {
                            Color(.white)
                        })
                        .cornerRadius(30)
                    
                }.scrollIndicators(.hidden)
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .frame(minWidth: 50, minHeight: 50)
                        .background(.white)
                        .clipShape(Circle())
                }
                .padding()
            }.onAppear {
                viewModel.fetchFeedback()
            }
        }.toolbar(.hidden)
            .sheet(isPresented: $feedbackIsShowed) {
                FeedbackView(viewModel: .init(feedbackType: .forProduct), isShowed: $feedbackIsShowed, objectId: product.id)
                    .presentationDetents([.fraction(0.5)])
            }
    }
    
    private func formatTimeStamp(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        var newDate = date
        newDate.removeLast()
        let dateString = dateFormatter.date(from: newDate)!
        dateFormatter.dateFormat = "dd-MM-yyy"
        return dateFormatter.string(from: dateString)
    }
}

struct ProductView_Previews: PreviewProvider {
    @State static var product = seedProduct
    @ObservedObject static var viewModel: ProductViewViewModel = .init(productId: 3)
    static var previews: some View {
        ProductView(product: seedProduct, viewModel: viewModel)
    }
}
