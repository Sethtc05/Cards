import Foundation
import SwiftUI

struct UserData: Hashable, Codable {
    var balance: Double
    var store: [Card]
    var collection: [Card]
    
    static func Create() -> UserData {
        return UserData(balance: 0.00, store: [Card](), collection: [Card]())
    }
}
