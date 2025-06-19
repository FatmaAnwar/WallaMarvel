//
//  MockCharacterMapper.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import WallaMarvelData
import WallaMarvelDomain

final class MockCharacterMapper: CharacterMapperProtocol {
    
    var receivedDTOs: [CharacterDataModel] = []
    var stubbedCharacters: [Character] = []
    
    func map(_ dtos: [CharacterDataModel]) -> [Character] {
        receivedDTOs = dtos
        return stubbedCharacters
    }
}
