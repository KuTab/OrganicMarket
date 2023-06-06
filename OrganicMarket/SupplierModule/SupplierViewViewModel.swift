//
//  UserViewViewModel.swift
//  OrganicMarket
//
//  Created by Egor Dadugin on 22.05.2023.
//

import Foundation
import Combine

class SupplierViewViewModel: ObservableObject {
    @Published var supplierFeedbacks: [SupplierFeedback] = []
    var supplierId: Int
    var updateFeedback: PassthroughSubject<Void, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()
    
    init(supplierId: Int) {
        self.supplierId = supplierId
        
        updateFeedback.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchFeedback()
            }.store(in: &cancellables)
    }
    
    func fetchFeedback() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            let publisher: AnyPublisher<ServerResponse<[SupplierFeedback]>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/feedback/getSupplierFeedback?ID=\(supplierId)",
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
