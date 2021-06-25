import SwiftUI

struct CardDetail: View {
    
    var card: Card
    var listType: ListType
    var fetch: Fetch
    
    @Environment(\.presentationMode) var presentationMode
    @State private var offset: CGFloat = -500.0
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            VStack (spacing: 0) {
 
                ScrollView {
                    
                     VStack (spacing: 0) {
                        
                            Image(card.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 350)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1))
                                .shadow(color: Color.black.opacity(0.6), radius: 6)
                                .padding()
                                .offset(x: 0.0, y: self.offset)
                                .onAppear {
                                    withAnimation(.easeOut(duration: 0.65)) { self.offset = 000.0 }
                                }
                            
                            Text(card.description)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                                .font(.callout)
                                .padding()
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
                GeometryReader { geometry in
                    Button(action: {
                        if self.listType == ListType.collection {
                            fetch.sell(card)
                        } else {
                            fetch.buy(card)
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("\(getButtonText()) for \(card.price, specifier: "$%.2f")")
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
                }
                .frame(maxHeight: 44)
                .padding(6)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.2))
    }
    
    func getButtonText() -> String {
        var buttonText = ""
        if self.listType == ListType.collection {
            buttonText = "Sell"
        } else {
            buttonText = "Buy"
        }
        return buttonText;
    }
}