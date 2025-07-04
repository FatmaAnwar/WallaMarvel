//
//  HeroCellViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation
import WallaMarvelDomain

final class HeroCellViewModel: HeroCellViewModelProtocol, ObservableObject, Equatable {
    let id: Int
    let character: Character
    
    var name: String { character.name }
    var imageURL: URL? {
        guard let url = URL(string: character.imageUrl),
              url.scheme == "https" || url.scheme == "http",
              url.host != nil else { return nil }
        return url
    }
    
    init(character: Character) {
        self.id = character.id
        self.character = character
    }
    
    static func == (lhs: HeroCellViewModel, rhs: HeroCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
