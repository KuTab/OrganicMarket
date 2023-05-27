import SwiftUI

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var messagesManager: MessagesManager
    var name: String
    var body: some View {
        NavigationView {
            VStack {
                VStack {
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
                        
                        TitleRow(name: name)
                    }
                    
                    if(messagesManager.messages.isEmpty) {
                        ZStack {
                            Color(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            Text("Нет сообщений")
                                .opacity(0.4)
                                .frame(alignment: .center)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .cornerRadius(30, corners: [.topLeft, .topRight])
                    }
                    else {
                        ScrollViewReader { proxy in
                            ScrollView {
                                
                                ForEach(messagesManager.messages, id: \.id) { message in
                                    MessageBubble(message: message, senderId: messagesManager.senderId)
                                }
                            }
                            .padding(.top, 10)
                            .background(Color.white)
                            .cornerRadius(30, corners: [.topLeft, [.topRight]])
                            .onChange(of: messagesManager.lastMessageId) { id in
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .bottom)
                                }
                            }
                        }.scrollIndicators(.hidden)
                    }
                }.background(Color("Peach"))
                
                MessageField()
                    .environmentObject(messagesManager)
            }
        }.toolbar(.hidden)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(messagesManager: .init(senderId: 9, chatId: nil), name: "Sarah Smith")
    }
}
