//
//  MemoryGameViewModel.swift
//  PartnerLab3
//
//  Created by Taina Saenz on 11/3/25.
//

import Foundation
import SwiftUI


class MemoryGameViewModel: ObservableObject {
    @Published private(set) var cards: [Card] = []
    @Published private(set) var selectedCards: [Int] = []
    
    private let flowers = ["flower1", "flower2","flower3", "flower4", "flower5", "flower6", "flower7", "flower8", "flower9","flower10", "flower11", "flower12"]
    
    
    init() {
        startNewGame()
    }

    
    func startNewGame() {
        cards = createGameCards(for: Array(flowers.prefix(6)))
        selectedCards = []
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
