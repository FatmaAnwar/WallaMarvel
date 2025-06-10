//
//  MarvelRepository.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

final class MarvelRepository: MarvelRepositoryProtocol {
    private let dataSource: MarvelRemoteDataSourceProtocol
    
    init(dataSource: MarvelRemoteDataSourceProtocol = MarvelRemoteDataSource()) {
        self.dataSource = dataSource
    }
    
    func getHeroes(offset: Int) async throws -> [Character] {
        let container = try await dataSource.getHeroes(offset: offset)
        return CharacterMapper.map(from: container)
    }
}
