import Foundation
import Combine

class OrdersViewViewModel: ObservableObject {
    @Published var orders: [Order] = []
    var cancellables: Set<AnyCancellable> = .init()
    
    func fetchUserOrders() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let publisher: AnyPublisher<ServerResponse<[Order]>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/order/myUserOrders",
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
                    self?.orders = response.data?.reversed() ?? []
                }.store(in: &cancellables)
            
        } catch {
        }
    }
    
    func fetchSupplierOrders() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let publisher: AnyPublisher<ServerResponse<[Order]>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/order/mySupplierOrders",
                method: .get,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"])
            
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("get supplier orders finished")
                    case .failure(let error):
                        print("get supplier orders error: \(error)")
                    }
                } receiveValue: { [weak self] response in
                    self?.orders = response.data?.reversed() ?? []
                }.store(in: &cancellables)
            
        } catch {
        }
    }
}
