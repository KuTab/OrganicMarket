import Foundation
import Combine

class ProductViewViewModel: ObservableObject {
    @Published var productFeedbacks: [ProductFeedback] = []
    var produtId: Int
    var updateFeedback: PassthroughSubject<Void, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()
    
    init(productId: Int) {
        self.produtId = productId
        
        updateFeedback.receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
            self?.fetchFeedback()
        }.store(in: &cancellables)
    }
    
    func fetchFeedback() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let publisher: AnyPublisher<ServerResponse<[ProductFeedback]>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/feedback/getProductFeedback?ID=\(produtId)",
                method: .get,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"])
            
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("get productFeedback publisher finished")
                    case .failure(let error):
                        print("get productFeedback error: \(error)")
                    }
                } receiveValue: { response in
                    self.productFeedbacks = response.data?.reversed() ?? []
                }.store(in: &cancellables)
            
        } catch {
        }
    }
}
