//
//  SharedHeroesListViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation

class SharedHeroesListViewModel {
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private(set) var allHeroes: [Character] = []
    private(set) var currentOffset: Int = 0
    private(set) var isLoading: Bool = false
    private let cacheRepository: CharacterCacheRepositoryProtocol
    
    init(
        getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes(),
        cacheRepository: CharacterCacheRepositoryProtocol = CharacterCacheRepository()
    ) {
        self.getHeroesUseCase = getHeroesUseCase
        self.cacheRepository = cacheRepository
    }
    
    func fetchMoreHeroes() async throws -> [HeroCellViewModel] {
        guard !isLoading else { return [] }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let characters = try await getHeroesUseCase.execute(offset: currentOffset)
            currentOffset += characters.count
            let newUniqueCharacters = characters.filter { newChar in
                !allHeroes.contains(where: { $0.id == newChar.id })
            }
            allHeroes += newUniqueCharacters
            
            try await cacheRepository.save(characters: allHeroes)
            
            return allHeroes.map { HeroCellViewModel(from: $0) }
            
        } catch {
            print("Network fetch failed. Attempting to load from cache.")
            
            if allHeroes.isEmpty {
                let cached = try cacheRepository.fetchCachedHeroes()
                allHeroes = cached
                return cached.map { HeroCellViewModel(from: $0) }
            }
            
            throw error
        }
    }
    
    func searchHeroes(_ query: String) -> [HeroCellViewModel] {
        let filtered: [Character]
        if query.isEmpty {
            filtered = allHeroes
        } else {
            filtered = allHeroes.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        }
        return filtered.map { HeroCellViewModel(from: $0) }
    }
    
    func reset() {
        currentOffset = 0
        allHeroes = []
        isLoading = false
    }
}
