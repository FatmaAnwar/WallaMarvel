//
//  SwiftUIHeroCellViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation

final class SwiftUIHeroCellViewModel: HeroCellViewModelProtocol, ObservableObject {
    let id: Int
    let character: Character
    
    var name: String { character.name }
    var imageURL: URL? { URL(string: character.imageUrl) }
    
    init(character: Character) {
        self.id = character.id
        self.character = character
    }
}
