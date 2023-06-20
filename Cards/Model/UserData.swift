import Foundation
import SwiftUI

// Structure that represents a specific users saved data.
struct UserData: Hashable, Codable {
    
    var users: [User]
    
    static func Create() -> UserData {
        return UserData(users: [User]())
    }
}
