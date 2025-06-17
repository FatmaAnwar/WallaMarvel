//
//  MockCharacterMapper.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
@testable import WallaMarvel

final class MockCharacterMapper: CharacterMapperProtocol {
    var expectedMappedCharacters: [Character] = []
    var receivedDTOs: [CharacterDataModel] = []
    
    func map(_ dtos: [CharacterDataModel]) -> [Character] {
        receivedDTOs = dtos
        return expectedMappedCharacters
    }
}
