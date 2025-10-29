// Partner Lab 2
// Group #2
// Taina Saenz and Tori Zhang
// October 14, 2025

import SwiftUI
internal import Combine

// Card struct for each card in the game
struct Card: Identifiable {
    let id = UUID()
    let imageName: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let x: CGFloat
    let y: CGFloat
    let rotation: Double
    let scale: CGFloat
}


class MemoryGameViewModel: ObservableObject {
    @Published private(set) var cards: [Card] = []
    @Published private(set) var selectedCards: [Int] = []
    @Published var showConfetti: Bool = false
    
    private let flowers = ["flower1", "flower2","flower3", "flower4", "flower5", "flower6", "flower7", "flower8", "flower9","flower10", "flower11", "flower12"]
    
    
    init() {
        startNewGame()
    }
    
    var isGameWon: Bool {
        !cards.isEmpty && cards.allSatisfy { $0.isMatched }
    }
    
    func startNewGame() {
        cards = createGameCards(for: Array(flowers.prefix(6)))
        selectedCards = []
        showConfetti = false
    }
    
    func selectCard(at index: Int) {
        guard index < cards.count, !cards[index].isMatched, !cards[index].isFaceUp else {
            return
        }
        
        cards[index].isFaceUp = true
        selectedCards.append(index)
        
        if selectedCards.count == 2 {
            checkForMatch()
        } else if selectedCards.count > 2 {
            let oldestIndex = selectedCards.removeFirst()
            cards[oldestIndex].isFaceUp = false
        }
    }
    
    private func createGameCards(for content: [String]) -> [Card] {
        var newCards: [Card] = []
        
        return newCards.shuffled()

    }
    
    
    private func checkForMatch() {
        
    }
}



// Main view/game layout which includes the grid and title
struct ContentView: View {
    @State private var cards: [Card] = []
    @State private var selectedCards: [Int] = []
    
    // Flower image names
    private let flowers = ["flower1", "flower2","flower3", "flower4", "flower5", "flower6", "flower7", "flower8", "flower9","flower10", "flower11", "flower12"]
    
    // columns for grid/layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    
    // Initializer to set up the game
    init() {
        // Adding init here to fit the single-view state model
        _cards = State(initialValue: createGameCards(for: Array(flowers.prefix(6))))
    }
    
    // Helper function to create the initial shuffled deck
    private func createGameCards(for content: [String]) -> [Card] {
        var newCards: [Card] = []
        for name in content {
            newCards.append(Card(imageName: name))
            newCards.append(Card(imageName: name))
        }
        return newCards.shuffled()
    }
    
    
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
                        ForEach(0..<cards.count, id: \.self) { index in
                            CardView(card: cards[index])
                                .aspectRatio(0.75, contentMode: .fit)
                                .onTapGesture {
                                    // Add animation for the flip effect
                                    withAnimation(.easeIn(duration:0.2)){
                                        tappedCard(at: index)
                                    }
                                }
                                .rotation3DEffect(.degrees(cards[index].isFaceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                                .opacity(cards[index].isMatched ? 0.3 : 1) // Fade matched cards
                        }
                    }
                    .padding()
                }
                
                // Add a button to reset the game
                Button("New Game") {
                    cards = createGameCards(for: Array(flowers.prefix(6)))
                    selectedCards = []
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.bottom, 20)
            }
        }
    }
    
    
    // Able to flip cards and see possible matches
    func tappedCard(at index: Int) {
        
         // 1. Check if the card is already matched or face up. If so, do nothing.
         if cards[index].isMatched || cards[index].isFaceUp {
             return
         }
         
         // 2. Flip the card up and add to selected list
         cards[index].isFaceUp = true
         selectedCards.append(index)
         
         // 3. Check for match when two cards are face up
         if selectedCards.count == 2 {
             let index1 = selectedCards[0]
             let index2 = selectedCards[1]
             
             // If the images match
             if cards[index1].imageName == cards[index2].imageName {
                 // IT'S A MATCH!
                 cards[index1].isMatched = true
                 cards[index2].isMatched = true
                 selectedCards = [] // Clear the selected list
                 
             } else {
                 // NOT A MATCH, flip them back down after a short delay
                 // Dispatch after 0.7 seconds allows the user to see the cards.
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                     withAnimation(.easeOut(duration: 0.2)) {
                         cards[index1].isFaceUp = false
                         cards[index2].isFaceUp = false
                         selectedCards = [] // Clear the selected list
                     }
                 }
             }
         } else if selectedCards.count > 2 {
             // This case handles the user tapping a third card quickly before the match check is done.
             // Flip the oldest card (the first one) back down.
             let oldestIndex = selectedCards.removeFirst() // Remove and get the first index
             cards[oldestIndex].isFaceUp = false
             
             // The selectedCards array now only contains the second card from the previous pair
             // and the newest card (current index), which is correct for checking the next pair.
         }
     }
 }


// CardView to show flower images
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

#Preview {
    ContentView()
}
