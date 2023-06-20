import Foundation

struct User: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var password: String
    var balance: Double
    var store: [Card]
    var collection: [Card]
}
