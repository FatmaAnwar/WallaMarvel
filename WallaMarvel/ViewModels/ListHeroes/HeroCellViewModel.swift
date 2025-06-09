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
    let originalHero: CharacterDataModel
    
    init(from model: CharacterDataModel) {
        self.name = model.name
        self.imageURL = URL(string: "\(model.thumbnail.path)/portrait_small.\(model.thumbnail.extension)")
        self.originalHero = model
    }
}

