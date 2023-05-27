import Foundation

struct SupplierFeedback: Codable, Hashable {
    let feedback: String
    let rate: Int
    let timeStamp: String
}

struct AddSupplierFeedback: Codable, Hashable {
    let feedback: String
    let rate: Int
    let supplierId: Int
    let timeStamp: String
}
