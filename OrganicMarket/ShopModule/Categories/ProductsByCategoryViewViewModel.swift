import Foundation
import Combine

class ProductByCategoryViewViewModel: ObservableObject {
    @Published var products: [Product] = []
    var cancellables: Set<AnyCancellable> = .init()

    func fetchProductByCategory(category: String) {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        let replacedCategory = category.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let publisher: AnyPublisher<ServerResponse<[Product]>, Error> = NetworkService.doRequest(
            with: "http://localhost:5012/api/products/byCategory?category=\(replacedCategory)",
            method: .get,
            headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"]
        )
        publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished fetching products by catgory")
                case .failure(let error):
                    print("fetching products by category error: \(error)")
                }
            } receiveValue: { response in
                self.products = response.data ?? []
            }.store(in: &cancellables)
    }
}
