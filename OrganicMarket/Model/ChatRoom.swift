import Foundation

struct ChatRoom: Codable, Hashable {
    let id: Int
    let userId: Int
    let supplierId: Int
    let receiverName: String
}
