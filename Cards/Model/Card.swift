import Foundation
import SwiftUI

struct Card: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var imageName: String
    var price: Double
    
    var image: Image {
        Image(imageName)
    }
}
