//
//  HeroesListViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI
import Network
import Combine

@MainActor
final class HeroesListViewModel: ObservableObject {
    @Published var heroCellViewModels: [HeroCellViewModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    @Published var showOfflineBanner: Bool = false
    @Published var showOnlineToast: Bool = false
    
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private let cacheRepository: CharacterCacheRepositoryProtocol
    private var currentOffset = 0
    private var allHeroes: [Character] = []
    private var cancellables = Set<AnyCancellable>()
    private var wasOffline = false
    
    init(
        getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes(),
        cacheRepository: CharacterCacheRepositoryProtocol = CharacterCacheRepository(),
        networkMonitor: NetworkMonitor = .shared
    ) {
        self.getHeroesUseCase = getHeroesUseCase
        self.cacheRepository = cacheRepository
        
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.handleNetworkChange(isConnected: isConnected)
            }
            .store(in: &cancellables)
    }
    
    func handleNetworkChange(isConnected: Bool) {
        if isConnected {
            if wasOffline {
                showOfflineBanner = false
                showOnlineToast = true
                
                Task {
                    await getHeroes(resetBeforeFetch: true)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.showOnlineToast = false
                }
                
                wasOffline = false
            }
        } else {
            wasOffline = true
            showOfflineBanner = true
            persistCurrentListIfNeeded()
        }
    }
    
    func initialLoad(isConnected: Bool) {
        if isConnected {
            Task {
                await getHeroes()
            }
        } else {
            preloadCachedHeroesIfAvailable()
            showOfflineBanner = true
        }
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
