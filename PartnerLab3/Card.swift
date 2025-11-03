//
//  Card.swift
//  PartnerLab3
//
//  Created by Taina Saenz on 11/3/25.
//

import Foundation

struct Card: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}
