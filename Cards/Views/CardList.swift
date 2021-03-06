import SwiftUI

// Setup a list of cards to choose from.

struct CardList: View {
    
    @ObservedObject var fetch: Fetch
    
    var cards: [Card]
    var listType: ListType
    
    var body: some View {

        // We no cards are display in the list, lets make it pretty instead of leaving it blank.
        // A nice image and an explanation of whats going on.
        if (cards.count == 0) {
            
            VStack(spacing: 30) {
                
                Spacer()
                
                Image(self.getImageName())
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color.gray)
                
                Text(self.getEmptyText())
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
            }
            
        } else {
            
            // We have cards to display in the list.
            NavigationView {

                List(cards) { card in
                    NavigationLink(destination: CardDetail(card: card, listType: listType, fetch: fetch)) {
                        CardRow(card: card)
                    }
                }
                .navigationTitle(self.getNavigationTitle())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        // If we are in my collection card list lets show in the page header what the total value of all my cards are.
                        // If we are in the store list lets show how much money we have available to buy more cards.
                        Text(self.listType == ListType.collection
                                ? "Worth: \(getTotal(), specifier: "$%.2f")"
                                : "Balance: \(fetch.userData.balance, specifier: "$%.2f")")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 14))
                    }
                }
            }
        }
    }
    
    // Let the user know which list they are currently in by displaying the name in the page navigation bar.
    func getNavigationTitle() -> String {
        var navigationTitle = "Store"
        
        if (listType == ListType.collection) {
            navigationTitle = "Collection"
        }
        
        return navigationTitle
    }
    
    // If the list is empty we display an image instead of an empty screen.
    // Found out what the image we want to display is called.
    func getImageName() -> String {
        var imageName = "store"
        
        if (listType == ListType.collection) {
            imageName = "collection"
        }
        
        return imageName
    }
    
    // If the list is empty we display an explanation of why instead of an empty screen.
    func getEmptyText() -> String {
        var emptyText = "The store is out of stock.\n\nTry selling some of your cards."
        
        if listType == ListType.collection {
            emptyText = "Your collection is empty.\n\nShop in the store for some cards."
        }
        
        return emptyText
    }
    
    // Add up the value of our collection of cards so we can see what they are all worth.
    func getTotal() -> Double {
        var total = 0.0
        
        for card in cards {
            total += card.price
        }
        
        return total
    }
}
