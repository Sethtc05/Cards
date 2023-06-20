import SwiftUI

struct CardDetail: View {
    
    var card: Card
    var listType: ListType
    
    @ObservedObject var fetch = CardsApp.fetch
    @Environment(\.presentationMode) var presentationMode
    
    @State private var offset: CGFloat = -500.0
    @State private var showingPaymentAlert = false
    
    var body: some View {
        
        // Vertical stack (one on top of the other vertically)
        VStack {
            
            // Lets scroll down to see more
            ScrollView {
                
                // Shows the card image and some information about the selected card.
                VStack {
                    
                    Text(card.name)
                        .bold()
                    
                    Spacer()
                        .frame(height: 15)
                    
                    Image(card.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 350)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.6), radius: 6)
                        .offset(x: 0.0, y: self.offset)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.65)) { self.offset = 000.0 }
                        }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(card.description)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .font(.callout)
                        .padding()
                }

            }
            
            Text("Balance: \(fetch.getBalance(), specifier: "$%.2f")")
                .foregroundColor(Color.blue)
                .font(.system(size: 14))
                .bold()
            
            Spacer()
                .frame(height: 5)
            
            // A buy or sell button strectched out to fill the screen horizontally.
            GeometryReader { geometry in
                
                Button(action: {
                    // The button has been pressed.
                    
                    // Are we in my collection?
                    if self.listType == ListType.collection {
                        
                        // We must be selling the card to the store for money.
                        showingPaymentAlert = false
                        fetch.sell(card)
                        
                    } else { // We must be in the store.
                        
                        // Do I have enough money to buy this card?
                        // If not, let the user know and prevent the purchase.
                        if ((fetch.getBalance() - card.price) < 0.00) {
                            showingPaymentAlert = true
                            return;
                        }
                        
                        // Buy the card.
                        fetch.buy(card)
                    }
                    
                    // Leave the card detail page and go back to the list we came from.
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    
                    // Set the text of the button based on whether we are in my collection or the store list (Buy or Sell).
                    Text("\(self.listType == ListType.collection ? "Sell" : "Buy") for \(card.price, specifier: "$%.2f")")
                        .frame(
                            minWidth: (geometry.size.width / 2) - 25,
                            maxWidth: .infinity,
                            minHeight: 44
                        )
                        .font(Font.subheadline.weight(.bold))
                        .background(self.listType == ListType.collection ? Color.red : Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(4)
                    
                }
                .alert(isPresented: $showingPaymentAlert) {
                    
                    // Sorry you don't have enough to buy this card. Play to win some more money!
                    Alert(
                        title: Text("Insufficient Funds"),
                        message: Text("You do not have enough money to buy this card."),
                        dismissButton: .default(Text("OK"))
                    )
                    
                }
            }
            .frame(maxHeight: 44)
            .padding(6)
        }
    }
}
