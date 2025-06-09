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
    
    func getHeroes(offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void) {
        apiClient.getHeroes(offset: offset, completionBlock: completionBlock)
    }
}

