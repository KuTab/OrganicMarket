import Foundation
import Combine

class FarmerViewModel: ObservableObject {
    @Published var products: [Product] = []
    var productUpdate: PassthroughSubject<Void, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    var productAdd: PassthroughSubject<Int, Never> = .init()
    
    init() {
        productUpdate.sink { _ in
            self.fetchMyProducts()
        }.store(in: &cancellables)
    }
    
    func fetchMyProducts() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        let publisher: AnyPublisher<ServerResponse<[Product]>, Error> = NetworkService.doRequest(
            with: "http://localhost:5012/api/products/my",
            method: .get,
            headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"]
        )
        publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished fetching products")
                case .failure(let error):
                    print("fetching products error: \(error)")
                }
            } receiveValue: { response in
                self.products = response.data ?? []
            }.store(in: &cancellables)
    }
}
