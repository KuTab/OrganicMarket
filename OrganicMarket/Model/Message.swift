import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    // Кому сообщение
    var receiverId: Int
    var timestamp: Date
}
