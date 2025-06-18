//
//  CharacterMapper.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation
import WallaMarvelDomain

public final class CharacterMapper: CharacterMapperProtocol {
    public init() {}
    
    public func map(_ dtos: [CharacterDataModel]) -> [Character] {
        dtos.map { dto in
            Character(
                id: dto.id,
                name: dto.name,
                imageUrl: dto.thumbnail.fullPath,
                description: dto.description ?? ""
            )
        }
    }
}
