import Foundation
import Combine

class UserEditingViewModel: ObservableObject {
    @Published var user: UserEditing
    var updatePublisher: PassthroughSubject<Void, Never>?
    var errorPublisher: PassthroughSubject<String, Never>?
    var cancellables: Set<AnyCancellable> = .init()
    
    func saveUpdates() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let body = try JSONEncoder().encode(user)
            let object = try JSONSerialization.jsonObject(with: body)
            let publisher: AnyPublisher<ServerResponse<String>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/users/updateMe",
                method: .put,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"],
                body: object as! [String : Any]
            )
            
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("update user publisher finished")
                    case .failure(let error):
                        print("update user error: \(error)")
                    }
                } receiveValue: { [weak self] response in
                    if response.success {
                        self?.updatePublisher?.send()
                    } else {
                        self?.errorPublisher?.send(response.message)
                    }
                }.store(in: &cancellables)
            
        } catch {
        }
    }
    
    init(user: User, updatePublisher: PassthroughSubject<Void, Never>?, errorPublisher: PassthroughSubject<String, Never>?) {
        self.user = .init(user: user)
        self.updatePublisher = updatePublisher
        self.errorPublisher = errorPublisher
    }
}
