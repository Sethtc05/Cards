import SwiftUI

struct PlayView: View {
    
    @ObservedObject var play: Play
    
    @State private var showingWinAlert = false
    @State private var winAmount = 0.00
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 20) {
                
                ForEach(0..<play.rows, id: \.self) { rowNumber in

                    HStack(spacing: 10) {
                        
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
                    
                    if (!play.isRunning && play.isEnabled) {
                        
                        play.start(winFunc: { balance in
                            winAmount = balance
                            CardsApp.fetch.balanceAmount += balance
                            showingWinAlert = true
                          })
                        
                    }
                    
                } label : {
                    
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
                    
                    Alert(
                        title: Text("Earnings"),
                        message: Text("You won \(winAmount)!"),
                        dismissButton: .default(Text("OK"))
                    )
                    
                }
                
                
            }
            .padding(10)
        }
    }
}
