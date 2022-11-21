import SwiftUI

// A view of the play game board.

struct PlayView: View {
    
    @ObservedObject var play: Play // The function behind the scence.
    @State private var showingWinAlert = false // Did we win? Let the user know.
    @State private var winAmount = 0.00 // We haven't won anything yet! let's play first.
    
    var body: some View {
        
        // Stretch the play board out to fill the whole screen.
        GeometryReader { geometry in
            
            // For each board square put the amount of money each square worth over the top of the square.
            VStack(spacing: 20) {
                
                // For each row on the play lets display a square with a money value.
                ForEach(0..<play.rows, id: \.self) { rowNumber in

                    HStack(spacing: 10) {
                        
                        // For each column on the play lets display a square with a money value.
                        ForEach(0..<play.columns, id: \.self) { colNumber in
   
                            Text("\(play.board[rowNumber, colNumber].value, specifier: "$%.2f")")
                                .frame(
                                    minWidth: (geometry.size.width / CGFloat(play.columns) - 20),
                                    maxWidth: .infinity,
                                    minHeight: (geometry.size.height / CGFloat(play.rows) - 45)
                                )
                                .font(Font.subheadline.weight(.bold))
                                .foregroundColor(play.board[rowNumber, colNumber].foregroundColor)
                                .background(play.board[rowNumber, colNumber].backgroundColor)
                                .cornerRadius(4)
                        }
                        
                    }
                    .padding(5)
                }
                
                Button {
                    
                    // Can we play yet?
                    if (!play.isRunning && play.isEnabled) {
                        
                        // Yes! lets play!
                        play.start(winFunc: { balance in
                            // When we win lets update our available balance with the amount we've won.
                            winAmount = balance
                            CardsApp.fetch.adjustBalance(balance)
                            showingWinAlert = true
                        })
                        
                    }
                    
                } label : {
                    
                    // Can we play or are we still waiting?
                    Text(play.isEnabled ? "Play" : "Wait \(play.waitSeconds) seconds")
                        .frame(
                            minWidth: (geometry.size.width / 2) - 25,
                            maxWidth: .infinity,
                            minHeight: 44
                        )
                        .font(Font.subheadline.weight(.bold))
                        .foregroundColor(Color.white)
                        .background(play.isEnabled ? Color.blue : Color.red)
                        .cornerRadius(4)
                    
                }
                .alert(isPresented: $showingWinAlert) {
                    
                    // We won! so let the user know about it.
                    Alert(
                        title: Text("Earnings"),
                        message: Text("You won \(winAmount, specifier: "$%.2f")!"),
                        dismissButton: .default(Text("OK"))
                    )
                    
                }
                
                
            }
            .padding(10)
        }
    }
}
