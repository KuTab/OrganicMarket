import SwiftUI

struct FarmerChatListView: View {
    @StateObject var viewModel: ChatListViewModel = .init()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Чаты")
                    .font(.system(size: 30))
                    .bold()
                    .padding()
                
                ScrollView {
                    ForEach(viewModel.chatRooms, id: \.self) { chatRoom in
                        NavigationLink(destination: ChatView(messagesManager: .init(senderId: chatRoom.userId, chatId: chatRoom.id), name: chatRoom.receiverName)) {
                            Text(chatRoom.receiverName)
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                                .background {
                                    Color.white
                                }.cornerRadius(20)
                                .shadow(color: .black.opacity(0.3), radius: 3)
                                .padding()
                        }.tint(.black)
                    }
                }
            }.onAppear {
                viewModel.fetchChats()
            }
        }
    }
}

struct FarmerChatListView_Previews: PreviewProvider {
    static var previews: some View {
        FarmerChatListView()
    }
}
