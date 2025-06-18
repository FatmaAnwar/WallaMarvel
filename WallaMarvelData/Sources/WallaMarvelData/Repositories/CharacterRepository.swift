//
//  CharacterRepository.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation
import WallaMarvelDomain

@MainActor
public final class CharacterRepository: CharacterRepositoryProtocol {
    
    private let remoteDataSource: MarvelRemoteDataSourceProtocol
    private let cacheRepository: CharacterCacheRepositoryProtocol
    private let characterMapper: CharacterMapperProtocol
    
    public init(
        remoteDataSource: MarvelRemoteDataSourceProtocol,
        cacheRepository: CharacterCacheRepositoryProtocol,
        characterMapper: CharacterMapperProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.cacheRepository = cacheRepository
        self.characterMapper = characterMapper
    }
    
    public func fetchCharacters(offset: Int) async throws -> [Character] {
        let dtoList: [CharacterDataModel] = try await remoteDataSource.fetchCharacters(offset: offset)
        return characterMapper.map(dtoList)
    }
    
    public func save(characters: [Character]) async throws {
        try await cacheRepository.save(characters: characters)
    }
    
    @MainActor
    public func fetchCachedHeroes() throws -> [Character] {
        try cacheRepository.fetchCachedHeroes()
    }
}
