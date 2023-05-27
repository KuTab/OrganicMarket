import Foundation
import Combine

class ChatListViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = []
    var cancellables: Set<AnyCancellable> = .init()
    
    func fetchChats() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let publisher: AnyPublisher<ServerResponse<[ChatRoom]>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/chat/getMyChats",
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
                    self?.chatRooms = response.data ?? []
                }.store(in: &cancellables)
            
        } catch {
        }
    }
}
