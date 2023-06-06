import Foundation
import Combine

class UserViewViewModel: ObservableObject {
    @Published var user: User?
    @Published var supplierFeedbacks: [SupplierFeedback] = []
    var updatePublisher: PassthroughSubject<Void, Never> = .init()
    var errorPublisher: PassthroughSubject<String, Never> = .init()
    @Published var errorShowed: Bool = false
    @Published var message: String = ""
    var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        updatePublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.fetchUser()
            }.store(in: &cancellables)
        
        errorPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.message = message
                self?.errorShowed = true
            }.store(in: &cancellables)
    }
    
    func fetchUser() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let publisher: AnyPublisher<ServerResponse<User>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/users/getMe",
                method: .get,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"])
            
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("get user publisher finished")
                    case .failure(let error):
                        print("get user error: \(error)")
                    }
                } receiveValue: { [weak self] response in
                    self?.user = response.data ?? .init(id: -1, email: "", isSupplier: false, rating: 5.0, address: "Test address", phone: "Test phone", name: "Test name", description: "Test description", surname: "Test Surname")
                    self?.fetchFeedback()
                }.store(in: &cancellables)
            
        } catch {
        }
    }
    
    func fetchFeedback() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let publisher: AnyPublisher<ServerResponse<[SupplierFeedback]>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/feedback/getSupplierFeedback?ID=\(user!.id)",
                method: .get,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"])
            
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("get supplierFeedback publisher finished")
                    case .failure(let error):
                        print("get supplierFeedback error: \(error)")
                    }
                } receiveValue: { response in
                    self.supplierFeedbacks = response.data?.reversed() ?? []
                }.store(in: &cancellables)
            
        } catch {
        }
    }
}
