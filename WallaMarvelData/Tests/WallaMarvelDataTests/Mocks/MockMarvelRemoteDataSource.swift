//
//  MockMarvelRemoteDataSource.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import WallaMarvelCore
import WallaMarvelData

final class MockMarvelRemoteDataSource: MarvelRemoteDataSourceProtocol {
    var shouldThrow = false
    var stubbedDTOs: [CharacterDataModel] = []
    
    func fetchCharacters(offset: Int) async throws -> [CharacterDataModel] {
        if shouldThrow {
            throw NetworkError.decodingError
        } else {
            return stubbedDTOs
        }
    }
}
