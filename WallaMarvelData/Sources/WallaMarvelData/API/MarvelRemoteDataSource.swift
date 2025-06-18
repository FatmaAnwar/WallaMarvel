//
//  MarvelRemoteDataSource.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

@MainActor
public final class MarvelRemoteDataSource: MarvelRemoteDataSourceProtocol {
    private let apiClient: MarvelAPIClientProtocol
    
    public init(apiClient: MarvelAPIClientProtocol = MarvelAPIClient()) {
        self.apiClient = apiClient
    }
    
    public func fetchCharacters(offset: Int) async throws -> [CharacterDataModel] {
        let container = try await apiClient.getHeroes(offset: offset)
        return container.characters
    }
}
