// Partner Lab 3
// Group #2
// Taina Saenz and Tori Zhang
// November 11, 2025

import Combine
import SwiftUI

// View model
class MemoryGameViewModel: ObservableObject {
    @Published private(set) var cards: [Card] = []
    @Published private(set) var selectedCards: [Int] = []
    
    // Flowers in game
    private let flowers = ["flower1", "flower2","flower3", "flower4", "flower5", "flower6", "flower7", "flower8", "flower9","flower10", "flower11", "flower12"]
    
    
    init() {
        startNewGame()
    }

    // Function for new game
    func startNewGame() {
        cards = createGameCards(for: Array(flowers.prefix(6)))
        selectedCards = []
    }
    
    
    // Function for selected cards
    func selectCard(at index: Int) {
        guard index < cards.count, !cards[index].isMatched, !cards[index].isFaceUp else {
            return
        }
        
        cards[index].isFaceUp = true
        selectedCards.append(index)
        
        if selectedCards.count == 2 {
            // checks if the cards chosen match
            checkForMatch()
        } else if selectedCards.count > 2 {
            let oldestIndex = selectedCards.removeFirst()
            cards[oldestIndex].isFaceUp = false
        }
    }
    
    // creates cards for game
    private func createGameCards(for content: [String]) -> [Card] {
        
        var newCards: [Card] = []
          for name in content {
              newCards.append(Card(imageName: name))
              newCards.append(Card(imageName: name))
          }
        return newCards.shuffled()

    }
    
    // func to check for match
    private func checkForMatch() {
        let index1 = selectedCards[0]
        let index2 = selectedCards[1]
                
        if cards[index1].imageName == cards[index2].imageName {
            cards[index1].isMatched = true
            cards[index2].isMatched = true
            selectedCards = []
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                guard let self = self else { return }
                withAnimation(.easeOut(duration: 0.2)) {
                    self.cards[index1].isFaceUp = false
                    self.cards[index2].isFaceUp = false
                    self.selectedCards = []
                }
                        
        }
    }
    }
}
