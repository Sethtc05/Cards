import SwiftUI

struct CardRow: View {
    
    var card: Card
    
    var body: some View {
        HStack {
            Image(card.imageName)
                .resizable()
                .frame(width: 50, height: 50)
            Text(card.name)
                .font(.subheadline)
                .lineLimit(1)
            Spacer()
        }
    }
}
