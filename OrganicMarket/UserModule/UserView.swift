import SwiftUI

enum UserTabs: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case info = "Информация"
    case feedback = "Отзывы"
}

struct UserView: View {
    @ObservedObject var viewModel: UserViewViewModel = .init()
    @State var selection: UserTabs = .info
    @State var isEditing: Bool = false
    var body: some View {
        VStack {
            if let user = viewModel.user {
                ZStack(alignment: .topTrailing) {
                    ScrollView {
                        StickyHeader {
                            Color(.red)
                        }
                        
                        VStack {
                            Text("\(user.name) \(user.surname)")
                                .font(.system(size: 28))
                                .bold()
                                .padding()
                          
                            Picker("Tabs", selection: $selection) {
                                ForEach(UserTabs.allCases) { tab in
                                    Text(tab.rawValue).tag(tab)
                                }
                            }.pickerStyle(.segmented)
                                .padding()
                            
                            switch selection {
                            case .info:
                                Group {
                                    Text("Электронная почта:")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                    
                                    Text(user.email)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    
                                    Divider()
                                    
                                    Text("Телефон:")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                    
                                    Text(user.phone)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    
                                    Divider()
                                }
                                
                                Group {
                                    Text("Адрес:")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                    
                                    Text(user.address)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                    
                                    Text("Описание:")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                    
                                    Text(user.description)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                }
                            case .feedback:
                                ForEach(viewModel.supplierFeedbacks, id: \.self) { feedback in
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
                            }
                        }.frame(maxWidth: .infinity)
                            .background(content: {
                                Color(.white)
                            })
                            .cornerRadius(30)
                    }
                    
                    Button {
                        isEditing = true
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.black)
                            .frame(minWidth: 50, minHeight: 50)
                            .background(.white)
                            .clipShape(Circle())
                    }.padding()

                }.sheet(isPresented: $isEditing) {
                    isEditing = false
                    viewModel.fetchUser()
                } content: {
                    UserEditingView(viewModel: .init(user: user, updatePublisher: viewModel.updatePublisher, errorPublisher: viewModel.errorPublisher), isShowed: $isEditing)
                        .presentationDetents([.fraction(0.85)])
                }
            }
            
        }.onAppear {
            viewModel.fetchUser()
        }
        .alert(isPresented: $viewModel.errorShowed) {
            Alert(title: Text("Ошибка"), message: Text(viewModel.message), dismissButton: .default(Text("Ок")))
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

struct UserView_Previews: PreviewProvider {
    @ObservedObject static var viewModel: UserViewViewModel = .init()
    static var previews: some View {
        UserView(viewModel: viewModel).onAppear {
            viewModel.user = seedUser
        }
    }
}
