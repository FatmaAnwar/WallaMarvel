//
//  MockMarvelAPIClient.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
@testable import WallaMarvel

final class MockRemoteDataSource: MarvelRemoteDataSourceProtocol {
    var shouldThrow: Bool = false
    var errorToThrow: Error = URLError(.badServerResponse)
    
    var mockCharacters: [CharacterDataModel] = []
    
    func fetchCharacters(offset: Int) async throws -> [CharacterDataModel] {
        if shouldThrow {
            throw errorToThrow
        }
        return mockCharacters
    }
}
