import SwiftUI

enum SupplierTabs: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case info = "Описание"
    case feedback = "Отзывы"
}


struct SupplierView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selection = SupplierTabs.info
    @State var user: User
    @State var feedbackIsShowed = false
    @StateObject var viewModel: SupplierViewViewModel
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                ScrollView(.vertical) {
                    StickyHeader {
                        Color(.red)
                    }
                    
                    VStack {
                        Text("\(String(describing: user.name)) \(String(describing: user.surname))")
                            .font(.system(size: 28))
                            .bold()
                            .padding()
                        
                        HStack {
                            OneStarView(rating: user.rating)
                            
                            Text(String(user.rating))
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
                            ForEach(SupplierTabs.allCases) { tab in
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
                            
                            //MARK: - View отзывов
                        case .feedback:
                            Text("Отзывы")
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
                            Button {
                                feedbackIsShowed = true
                            } label: {
                                Text("Оставить отзыв")
                            }.buttonStyle(.bordered)
                        }
                        
                    }.frame(maxWidth: .infinity)
                        .background(content: {
                            Color(.white)
                        })
                        .cornerRadius(30)
                    
                }.scrollIndicators(.hidden)
                
                HStack {
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
                    
                    Spacer()
                    
                    NavigationLink(destination: ChatView(messagesManager: .init(senderId: user.id, chatId: nil), name: "\(user.name) \(user.surname)")) {
                        Image(systemName: "message.fill")
                            .foregroundColor(.black)
                            .frame(minWidth: 50, minHeight: 50)
                            .background(.white)
                            .clipShape(Circle())
                            .padding()
                    }.tint(.black)
                }.frame(maxWidth: .infinity, alignment: .leading)
                
            }.onAppear {
                viewModel.fetchFeedback()
            }
        }.toolbar(.hidden)
            .sheet(isPresented: $feedbackIsShowed) {
                FeedbackView(viewModel: .init(feedbackType: .forSupplier), isShowed: $feedbackIsShowed, objectId: user.id)
                    .presentationDetents([.fraction(0.5)]).onAppear {
                        print(viewModel.supplierFeedbacks)
                    }.onDisappear {
                        print(viewModel.supplierFeedbacks.count)
                    }
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

struct SupplierView_Previews: PreviewProvider {
    @State static var user = seedUser
    @ObservedObject static var viewModel: SupplierViewViewModel = .init(supplierId: user.id)
    static var previews: some View {
        SupplierView(user: user, viewModel: viewModel)
    }
}
