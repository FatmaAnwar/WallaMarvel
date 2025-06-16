//
//  HeroCellViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

struct HeroCellViewModel: Identifiable {
    let id: Int
    let name: String
    let imageURL: URL?
    let originalHero: Character
    
    init(from model: Character) {
        self.id = model.id
        self.name = model.name
        if let url = URL(string: model.imageUrl),
           let scheme = url.scheme,
           (scheme == "http" || scheme == "https"),
           url.host != nil {
            self.imageURL = url
        } else {
            self.imageURL = nil
        }
        self.originalHero = model
    }
}
