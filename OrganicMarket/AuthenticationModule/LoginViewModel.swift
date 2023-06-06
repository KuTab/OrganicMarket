import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var isSupplier: Bool = false
    @Published var registered: Bool = false //(UserDefaults.standard.value(forKey: "registered") as? Bool) ?? false
    @Published var loggedIn: Bool = false //(UserDefaults.standard.value(forKey: "loggedIn") as? Bool) ?? false
    @Published var showAllert: Bool = false
    @Published var message: String = ""
    var cancellables = Set<AnyCancellable>()
    
    func register() {
        do {
            let body = try JSONEncoder().encode(RegisterModel(email: self.email, password: self.password, name: self.name, surname: self.surname, isSupplier: self.isSupplier))
            let object = try JSONSerialization.jsonObject(with: body)
            
            let publisher: AnyPublisher<ServerResponse<LoginDto>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/auth/register",
                method: .post,
                headers: ["accept" : "application/json", "Content-Type" : "application/json"],
                body: object as! [String : Any]
            )
            publisher.receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("register publisher finished")
                    case .failure(let error):
                        print("register error: \(error)")
                    }
                } receiveValue: { response in
                    if response.success {
                        if let data = response.data {
                            self.registered = true
                            self.loggedIn = true
                            UserDefaults.standard.set(data.token, forKey: "token")
                            self.isSupplier = data.isSupplier
                            UserDefaults.standard.setValue(true, forKey: "registered")
                            UserDefaults.standard.setValue(true, forKey: "loggedIn")
                            
                        }
                    } else {
                        self.showAllert = true
                        self.message = response.message
                        }
                    }.store(in: &cancellables)
                } catch {
                    
                }
        }
        
        func login() {
            do {
                let body = try JSONEncoder().encode(LoginModel(email: self.email, password: self.password))
                let object = try JSONSerialization.jsonObject(with: body)
                
                let publisher: AnyPublisher<ServerResponse<LoginDto>, Error> = NetworkService.doRequest(
                    with: "http://localhost:5012/api/auth/login",
                    method: .post,
                    headers: ["accept" : "application/json", "Content-Type" : "application/json"],
                    body: object as! [String : Any]
                )
                publisher.receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("login publisher finished")
                        case .failure(let error):
                            print("login error: \(error)")
                        }
                    } receiveValue: { response in
                        if response.success {
                            if let data = response.data {
                                self.registered = true
                                self.loggedIn = true
                                UserDefaults.standard.set(data.token, forKey: "token")
                                self.isSupplier = data.isSupplier
                                UserDefaults.standard.setValue(true, forKey: "registered")
                                UserDefaults.standard.setValue(true, forKey: "loggedIn")
                            }
                        } else {
                            self.showAllert = true
                            self.message = response.message
                        }
                    }.store(in: &cancellables)
            } catch {
                
            }
        }
    }
    
    struct RegisterModel: Codable {
        let email: String
        let password: String
        let name: String
        let surname: String
        let isSupplier: Bool
    }
    
    struct LoginModel: Codable {
        let email: String
        let password: String
    }
    
    struct ServerResponse<T: Codable>: Codable {
        let data: T?
        let success: Bool
        let message: String
    }
