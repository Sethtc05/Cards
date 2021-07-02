import Foundation
import SwiftUI

// Structure that represents a specific users saved data.
struct UserData: Hashable, Codable {
    
    var balance: Double
    var store: [Card]
    var collection: [Card]
    
    static func Create() -> UserData {
        return UserData(balance: 0.00, store: [Card](), collection: [Card]())
    }
}
