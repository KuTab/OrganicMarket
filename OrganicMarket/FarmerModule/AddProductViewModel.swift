import Foundation
import Combine

class AddProductViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var price: Double = 0
    @Published var weight: Double = 0
    @Published var description: String = ""
    @Published var category: String = ""
    @Published var composition: String = ""
    @Published var expiration: String = ""
    @Published var storageCondition: String = ""
    @Published var cancellables: Set<AnyCancellable> = .init()
    var rating = 0.0
    
    func addProduct(updatePublisher: PassthroughSubject<Void, Never>) {
        do {
            let product = AddProduct(title: self.title,
                                     price: self.price,
                                     weight: self.weight,
                                     rating: self.rating,
                                     description: self.description,
                                     category: self.category,
                                     composition: self.composition,
                                     expiration: self.expiration,
                                     storageCondition: self.storageCondition)
            let body = try JSONEncoder().encode(product)
            let object = try JSONSerialization.jsonObject(with: body)
            
            let token = UserDefaults.standard.value(forKey: "token") ?? ""
            let publisher: AnyPublisher<ServerResponse<String>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/products/add",
                method: .post,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"],
                body: object as! [String : Any]
            )
            publisher.sink { completion in
                switch completion {
                case .finished:
                    print("finished fetching products")
                case .failure(let error):
                    print("fetching products error: \(error)")
                }
            } receiveValue: { response in
                print(response.data)
                updatePublisher.send()
            }.store(in: &cancellables)
        } catch {}
    }
}
