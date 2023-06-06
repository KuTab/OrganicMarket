import Foundation
import Combine
import SwiftUI
import PhotosUI

class AddProductViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var price: Double = 0
    @Published var weight: Double = 0
    @Published var description: String = ""
    @Published var category: String = ""
    @Published var composition: String = ""
    @Published var storageCondition: String = ""
    @Published var categories: [String] = []
    @Published var expirationDate: Date = Date.now
    @Published var metric: String = ""
    @Published var quantity: Int = 0
    @Published var photoItem: PhotosPickerItem?
    var metrics = ["г.", "кг.", "мл.", "л."]
    @Published var photo: String = ""
    @Published var cancellables: Set<AnyCancellable> = .init()
    var rating = 0.0
    
    func addProduct(updatePublisher: PassthroughSubject<Void, Never>) {
        do {
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let expiration = dateFormatter.string(from: self.expirationDate)
            let product = AddProduct(title: self.title,
                                     price: self.price,
                                     weight: self.weight,
                                     rating: self.rating,
                                     description: self.description + "Metric" + self.metric,
                                     category: self.category,
                                     composition: self.composition,
                                     expiration: expiration,
                                     quantity: self.quantity,
                                     image: self.photo,
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
