//
//  MarvelRemoteDataSource.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

final class MarvelRemoteDataSource: MarvelRemoteDataSourceProtocol {
    private let apiClient: MarvelAPIClientProtocol

    init(apiClient: MarvelAPIClientProtocol = MarvelAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchCharacters(offset: Int) async throws -> [CharacterDataModel] {
        let container = try await apiClient.getHeroes(offset: offset)
        return container.characters
    }
}
