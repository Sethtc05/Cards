import SwiftUI

extension View {

    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            self.hidden()
        }
        else {
            self
        }
    }
    
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

extension [Card] {
    
    func sort() -> [Card] {
        self.sorted { $0.name < $1.name }
    }
    
    // Add up the value of our collection of cards so we can see what they are all worth.
    func getTotal() -> Double {
        var total = 0.0
        
        for card in self {
            total += card.price
        }
        
        return total
    }
}
