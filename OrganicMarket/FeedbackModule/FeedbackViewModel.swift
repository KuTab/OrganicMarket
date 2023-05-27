import Foundation
import Combine

enum FeedbackType {
    case forProduct
    case forSupplier
}

class FeedbackViewModel: ObservableObject {
    static var feedbackPlaceholder = "Оставьте комментарий"
    @Published var feedback: String = feedbackPlaceholder
    @Published var rate: Int = 0
    @Published var isShowed = true
    var feedbackType: FeedbackType
    var cancellables: Set<AnyCancellable> = .init()
    
    public init(feedbackType: FeedbackType) {
        self.feedbackType = feedbackType
    }
    
    func sendProductFeedback(productId: Int) {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let dateString = getStringDate()
            let body = try JSONEncoder().encode(AddProductFeedback(feedback: self.feedback,
                                                                   rate: self.rate,
                                                                   productId: productId,
                                                                   timeStamp: dateString))
            let object = try JSONSerialization.jsonObject(with: body)
            let publisher: AnyPublisher<ServerResponse<String>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/feedback/postProductFeedback",
                method: .post,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"],
                body: object as! [String : Any])
            
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("productFeedback publisher finished")
                        self.isShowed = false
                    case .failure(let error):
                        print("productFeedback error: \(error)")
                    }
                } receiveValue: { response in
                    print(response)
                }.store(in: &cancellables)
            
        } catch {
        }
    }
    
    func sendSupplierFeedback(supplierId: Int) {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let dateString = getStringDate()
            let body = try JSONEncoder().encode(AddSupplierFeedback(feedback: self.feedback,
                                                                    rate: self.rate,
                                                                    supplierId: supplierId,
                                                                    timeStamp: dateString))
            let object = try JSONSerialization.jsonObject(with: body)
            
            let publisher: AnyPublisher<ServerResponse<String>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/feedback/postSupplierFeedback",
                method: .post,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"],
                body: object as! [String : Any])
            
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("supplierFeedback publisher finished")
                        self.isShowed = false
                    case .failure(let error):
                        print("supplierFeedback error: \(error)")
                    }
                } receiveValue: { response in
                    print(response)
                }.store(in: &cancellables)
            
        } catch {
        }
    }
    
    private func getStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let dateString = dateFormatter.string(from: Date.now) + "Z"
        return dateString
    }
}
