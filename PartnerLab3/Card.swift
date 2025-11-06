// Partner Lab 3
// Group #2
// Taina Saenz and Tori Zhang
// November 11, 2025

import Foundation

struct Card: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}
