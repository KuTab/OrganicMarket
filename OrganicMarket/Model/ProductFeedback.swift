import Foundation

struct ProductFeedback: Codable, Hashable {
    let feedback: String
    let rate: Int
    let timeStamp: String
}

struct AddProductFeedback: Codable, Hashable {
    let feedback: String
    let rate: Int
    let productId: Int
    let timeStamp: String
}
