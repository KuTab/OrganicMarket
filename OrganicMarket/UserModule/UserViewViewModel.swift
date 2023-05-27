//
//  UserViewViewModel.swift
//  OrganicMarket
//
//  Created by Egor Dadugin on 23.05.2023.
//

import Foundation
import Combine

class UserViewViewModel: ObservableObject {
    @Published var user: User?
    @Published var supplierFeedbacks: [SupplierFeedback] = []
    var cancellables: Set<AnyCancellable> = .init()
    
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
                    self?.user = response.data ?? .init(id: -1, email: "", isSupplier: false, rating: 5.0, address: "Test address", phone: "Test phone", name: "Test name", surname: "Test Surname")
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
                    self.supplierFeedbacks = response.data ?? []
                }.store(in: &cancellables)
            
        } catch {
        }
    }
}
