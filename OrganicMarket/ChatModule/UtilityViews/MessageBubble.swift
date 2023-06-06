import SwiftUI

struct MessageBubble: View {
    var message: Message
    // MARK: - Id пользователя с которым общаемся
    var senderId: Int
    @State var showTime: Bool = false
    var body: some View {
        VStack(alignment: message.receiverId != senderId ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.receiverId != senderId ? Color("Gray") : Color("Peach"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.receiverId != senderId ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text(formatDate(date: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.receiverId != senderId ? .leading : .trailing)
                    .padding(.horizontal, 10)
            }
        }.frame(maxWidth: .infinity, alignment: message.receiverId != senderId ? .leading : .trailing)
            .padding(message.receiverId != senderId ? .leading : .trailing)
            .padding(.horizontal, 10)
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "12345", text: "I've been coding SwiftUI applications from scratch and it's so much fun", receiverId: 0, timestamp: Date()), senderId: 9)
    }
}
