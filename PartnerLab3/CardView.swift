// Partner Lab 3
// Group #2
// Taina Saenz and Tori Zhang
// November 11, 2025

import SwiftUI


struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 12)
            
            if card.isFaceUp || card.isMatched {
                // Face up state: show the image content
                shape
                    .fill(Color.white)
                shape
                    .stroke(card.isMatched ? Color.green : Color.blue, lineWidth: 3)
                
                Image(card.imageName) // Display the content
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                
            } else {
                // Face down state: show the card back (blue rectangle)
                shape
                    .fill(Color.blue)
            }
        }
    }
}
