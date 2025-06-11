//
//  HeroesListViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI

@MainActor
final class HeroesListViewModel: ObservableObject {
    @Published var heroCellViewModels: [HeroCellViewModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private let cacheRepository: CharacterCacheRepositoryProtocol
    private var currentOffset = 0
    private var allHeroes: [Character] = []
    
    static let shared = HeroesListViewModel()
    
    init(
        getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes(),
        cacheRepository: CharacterCacheRepositoryProtocol = CharacterCacheRepository()
    ) {
        self.getHeroesUseCase = getHeroesUseCase
        self.cacheRepository = cacheRepository
    }
    
    func getHeroes(resetBeforeFetch: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        
        if resetBeforeFetch {
            currentOffset = 0
            allHeroes = []
            heroCellViewModels = []
        }
        
        do {
            let characters = try await getHeroesUseCase.execute(offset: currentOffset)
            currentOffset += characters.count
            
            let newUniqueCharacters = characters.filter { newChar in
                !allHeroes.contains(where: { $0.id == newChar.id })
            }
            allHeroes += newUniqueCharacters
            
            filterHeroes()
            try await cacheRepository.save(characters: allHeroes)
        } catch {
            print("Error fetching heroes: \(error.localizedDescription)")
            
            if allHeroes.isEmpty {
                if let cached = try? cacheRepository.fetchCachedHeroes() {
                    allHeroes = cached
                    filterHeroes()
                }
            }
        }
        
        isLoading = false
    }
    
    func loadMoreIfNeeded(currentItem: HeroCellViewModel) {
        guard let lastItem = heroCellViewModels.last else { return }
        if currentItem.name == lastItem.name {
            Task {
                await getHeroes()
            }
        }
    }
    
    func filterHeroes() {
        let filtered: [Character]
        
        if searchText.isEmpty {
            filtered = allHeroes
        } else {
            filtered = allHeroes.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        let uniqueSorted = Dictionary(grouping: filtered, by: \.id)
            .compactMap { $0.value.first }
            .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        
        heroCellViewModels = uniqueSorted.map { HeroCellViewModel(from: $0) }
    }
    
    func preloadCachedHeroesIfAvailable() {
        if allHeroes.isEmpty,
           let cached = try? cacheRepository.fetchCachedHeroes() {
            allHeroes = cached
            filterHeroes()
            
            Task {
                try? await cacheRepository.save(characters: allHeroes)
            }
        }
    }
    
    func persistCurrentListIfNeeded() {
        if !allHeroes.isEmpty {
            Task {
                try? await cacheRepository.save(characters: allHeroes)
            }
        }
    }
}
