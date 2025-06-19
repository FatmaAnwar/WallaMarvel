//
//  MockMarvelAPIClient.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import WallaMarvelCore
@testable import WallaMarvelData

@MainActor
final class MockMarvelAPIClient: MarvelAPIClientProtocol {
    var shouldThrow = false
    var stubbedCharacters: [CharacterDataModel] = []
    var receivedOffset: Int?
    
    func getHeroes(offset: Int) async throws -> CharacterDataContainer {
        receivedOffset = offset
        if shouldThrow {
            throw NetworkError.decodingError
        }
        return CharacterDataContainer(
            count: stubbedCharacters.count,
            limit: 20,
            offset: offset,
            characters: stubbedCharacters
        )
    }
}
