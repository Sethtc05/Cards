import SwiftUI

extension View {

    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
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
