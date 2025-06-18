//
//  CharacterDataContainer.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

public struct CharacterDataContainer: Decodable {
    let count: Int
    let limit: Int
    let offset: Int
    let characters: [CharacterDataModel]
    
    enum CodingKeys: String, CodingKey {
        case count, limit, offset
        case characters = "results"
    }
}
