// Partner Lab 2
// Group #2
// Taina Saenz and Tori Zhang
// October 14, 2025

import SwiftUI

// Main view/game layout which includes the grid and title
struct ContentView: View {
    @StateObject private var viewModel = MemoryGameViewModel()
    
    
    // columns for grid/layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
 
    
    
    var body: some View {
        ZStack {
            // Game Title
            VStack {
                Text("Game")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                // Grid of cards, able to scroll through
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(0..<viewModel.cards.count, id: \.self) { index in
                            CardView(card: viewModel.cards[index])
                                .aspectRatio(0.75, contentMode: .fit)
                                .onTapGesture {
                                    // Add animation for the flip effect
                                    withAnimation(.easeIn(duration:0.2)){
                                        viewModel.selectCard(at: index)
                                    }
                                }
                                .rotation3DEffect(.degrees(viewModel.cards[index].isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                                .opacity(viewModel.cards[index].isMatched ? 0.3 : 1) // Fade matched cards
                        }
                    }
                    .padding()
                }
                
                // Add a button to reset the game
                Button("New Game") {
                    viewModel.startNewGame()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.bottom, 20)
            }
        }
    }
    
    
}




#Preview {
    ContentView()
}
