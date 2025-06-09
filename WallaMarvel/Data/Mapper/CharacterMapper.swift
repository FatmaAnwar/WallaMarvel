//
//  CharacterMapper.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

struct CharacterMapper {
    static func map(from model: CharacterDataModel) -> Character {
        let imageURL = "\(model.thumbnail.path).\(model.thumbnail.extension)"
        return Character(
            id: model.id,
            name: model.name,
            imageUrl: imageURL,
            description: model.description ?? "No description"
        )
    }
    
    static func map(from container: CharacterDataContainer) -> [Character] {
        return container.characters.map { map(from: $0) }
    }
}
