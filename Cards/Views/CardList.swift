import SwiftUI

struct CardList: View {
    
    @ObservedObject var fetch: Fetch
    
    var cards: [Card]
    var listType: ListType
    
    var body: some View {

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
                        Text(self.listType == ListType.collection
                                ? "Worth: \(getTotal(), specifier: "$%.2f")"
                                : "Balance: \(getBalance(), specifier: "$%.2f")")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 14))
                    }
                }
            }
        }
    }
    
    func getNavigationTitle() -> String {
        var navigationTitle = "Store"
        
        if (listType == ListType.collection) {
            navigationTitle = "Collection"
        }
        
        return navigationTitle
    }
    
    func getImageName() -> String {
        var imageName = "store"
        
        if (listType == ListType.collection) {
            imageName = "collection"
        }
        
        return imageName
    }
    
    func getEmptyText() -> String {
        var emptyText = "The store is out of stock.\n\nTry selling some of your cards."
        
        if listType == ListType.collection {
            emptyText = "Your collection is empty.\n\nShop in the store for some cards."
        }
        
        return emptyText
    }
    
    func getTotal() -> Double {
        var total = 0.0
        
        for card in cards {
            total += card.price
        }
        
        return total
    }
    
    func getBalance() -> Double {
        return fetch.balanceAmount;
    }
}
