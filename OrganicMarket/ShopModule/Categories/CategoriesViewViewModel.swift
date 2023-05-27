import Foundation
import Combine

class CategoriesViewViewModel: ObservableObject {
    @Published var categories: [String] = []
    var cancellables: Set<AnyCancellable> = .init()
    
    func fetchCategories() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        let publisher: AnyPublisher<ServerResponse<[String]>, Error> = NetworkService.doRequest(
            with: "http://localhost:5012/api/products/categories",
            method: .get,
            headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"]
        )
        publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished fetching catgories")
                case .failure(let error):
                    print("fetching categories error: \(error)")
                }
            } receiveValue: { response in
                self.categories = response.data ?? []
            }.store(in: &cancellables)
    }
}
