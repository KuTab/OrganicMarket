import Foundation

struct Order: Codable, Hashable {
    let id: Int
    let userId: Int
    let userName: String
    let products: [Product]
}
