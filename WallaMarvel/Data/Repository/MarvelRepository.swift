//
//  MarvelRepository.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

final class MarvelRepository: MarvelRepositoryProtocol {
    
    private let remoteDataSource: MarvelRemoteDataSourceProtocol
    private let cacheRepository: CharacterCacheRepositoryProtocol
    private let characterMapper: CharacterMapperProtocol
    
    init(
        remoteDataSource: MarvelRemoteDataSourceProtocol = MarvelRemoteDataSource(),
        cacheRepository: CharacterCacheRepositoryProtocol = CharacterCacheRepository(),
        characterMapper: CharacterMapperProtocol = CharacterMapper()
    ) {
        self.remoteDataSource = remoteDataSource
        self.cacheRepository = cacheRepository
        self.characterMapper = characterMapper
    }
    
    func fetchCharacters(offset: Int) async throws -> [Character] {
        let dtoList: [CharacterDataModel] = try await remoteDataSource.fetchCharacters(offset: offset)
        return characterMapper.map(dtoList)
    }
    
    func save(characters: [Character]) async throws {
        try await cacheRepository.save(characters: characters)
    }
    
    func fetchCachedHeroes() throws -> [Character] {
        try cacheRepository.fetchCachedHeroes()
    }
}
