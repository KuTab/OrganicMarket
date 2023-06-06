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
    let quantity: Int
    let image: String
    let supplier: User
    
    func getMetric() -> String {
        let components = self.description.components(separatedBy: "Metric")
        if components.count >= 2 {
            return components[1]
        } else {
            return ""
        }
    }
    
    func getDescription() -> String {
        let components = self.description.components(separatedBy: "Metric")
        if components.count >= 1 {
            return components[0]
        } else {
            return ""
        }
    }
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
    let quantity: Int
    let image: String
    let storageCondition: String
}

var seedProduct: Product = Product(
    id: 0,
    title: "TestProduct",
    price: 200,
    weight: 100,
    rating: 5,
    description: "TestDescriptionMetricг.",
    category: "Fruits",
    composition: "TestComposition",
    expiration: "14 days",
    storageCondition: "None",
    quantity: 1,
    image: "",
    supplier: User(id: 0, email: "TestEmail", isSupplier: true, rating: 5.0, address: "Test address", phone: "Test phone", name: "Test name", description: "Test description", surname: "Test Surname"))

