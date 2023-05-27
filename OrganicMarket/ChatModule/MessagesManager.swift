import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class MessagesManager: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId = ""
    var senderId: Int
    var collectionName: String = "messages"
    var cancellables: Set<AnyCancellable> = .init()
    let db = Firestore.firestore()
    
    init(senderId: Int, chatId: Int?) {
        self.senderId = senderId
        if let chatId = chatId {
            collectionName += String(chatId)
            getMessages()
        } else {
            getChat()
        }
    }
    
    func getMessages() {
        db.collection(collectionName).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents \(error)")
                return
            }
            
            self.messages = documents.compactMap { document -> Message? in
                do {
                    return try document.data(as: Message.self)
                } catch {
                    print("Error decoding document into Message: \(error)")
                    return nil
                }
            }
            
            self.messages.sort { $0.timestamp < $1.timestamp }
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
        }
    }
    
    func senMessage(text: String) {
        do {
            let newMessage = Message(id: "\(UUID())", text: text, receiverId: senderId, timestamp: Date())
            try db.collection(collectionName).document().setData(from: newMessage)
        } catch {
            print("Error adding message to firestore: \(error)")
        }
    }
    
    func getChat() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let publisher: AnyPublisher<ServerResponse<Int>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/chat/getChat?receiverId=\(senderId)",
                method: .get,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"])
            
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("get user orders finished")
                    case .failure(let error):
                        print("get user orders: \(error)")
                    }
                } receiveValue: { [weak self] response in
                    if let chatId = response.data {
                        self?.collectionName += String(chatId)
                        self?.getMessages()
                    }
                }.store(in: &cancellables)
            
        } catch {
        }
    }
}
