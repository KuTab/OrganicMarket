import Foundation

struct CreateOrder: Codable, Hashable {
    var products: [ProductOrder] = .init()
}

struct ProductOrder: Codable, Hashable {
    let productId: Int
}
