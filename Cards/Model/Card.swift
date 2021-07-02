import Foundation
import SwiftUI

// A data structure that represents a single 'Card'.

struct Card: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var imageName: String
    var price: Double
    
    // Each card has an image loaded from the assets file.
    var image: Image {
        Image(imageName)
    }
}
