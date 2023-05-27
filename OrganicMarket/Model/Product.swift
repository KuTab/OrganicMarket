import Foundation

struct Product: Codable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let weight: Double
    let rating: Double
    let description: String
    let category: String
    let composition: String
    let expiration: String
    let storageCondition: String
    let supplier: User
}

struct AddProduct: Codable, Hashable {
    let title: String
    let price: Double
    let weight: Double
    let rating: Double
    let description: String
    let category: String
    let composition: String
    let expiration: String
    let storageCondition: String
}

var seedProduct: Product = Product(
    id: 0,
    title: "TestProduct",
    price: 200,
    weight: 100,
    rating: 5,
    description: "TestDescription",
    category: "Fruits",
    composition: "TestComposition",
    expiration: "14 days",
    storageCondition: "None",
    supplier: User(id: 0, email: "TestEmail", isSupplier: true, rating: 5.0, address: "Test address", phone: "Test phone", name: "Test name", surname: "Test Surname"))

