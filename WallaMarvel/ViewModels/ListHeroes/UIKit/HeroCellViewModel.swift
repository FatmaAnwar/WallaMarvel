//
//  HeroCellViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

struct HeroCellViewModel {
    let name: String
    let imageURL: URL?
    let originalHero: Character
    
    init(from model: Character) {
        self.name = model.name
        self.imageURL = URL(string: model.imageUrl)
        self.originalHero = model
    }
}
