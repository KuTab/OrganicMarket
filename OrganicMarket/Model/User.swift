import Foundation

struct User: Codable, Hashable {
    let id: Int
    let email: String
    let isSupplier: Bool
    let rating: Double
    let address: String
    let phone: String
    let name: String
    let surname: String
}

struct UserEditing: Codable, Hashable {
    var id: Int = 0
    var email: String
    var address: String
    var phone: String
    var name: String
    var surname: String
    
    init(user: User) {
        self.email = user.email
        self.address = user.address
        self.phone = user.phone
        self.name = user.name
        self.surname = user.surname
    }
}

struct LoginDto: Codable, Hashable {
    let token: String
    let isSupplier: Bool
}

var seedUser = User(id: 8, email: "TestEmail", isSupplier: true, rating: 5.0, address: "Test address", phone: "Test phone", name: "Test name", surname: "Test Surname")
