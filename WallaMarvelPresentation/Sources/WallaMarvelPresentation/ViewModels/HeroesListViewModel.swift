//
//  HeroesListViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import Combine
import SwiftUI
import WallaMarvelDomain
import WallaMarvelCore

@MainActor
final class HeroesListViewModel: ObservableObject {
    @Published var heroCellViewModels: [HeroCellViewModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let fetchHeroesUseCase: FetchCharactersUseCaseProtocol
    private let networkMonitor: NetworkMonitoringProtocol
    private let debounceDuration: TimeInterval = 0.4
    private var cancellables = Set<AnyCancellable>()
    private var currentOffset = 0
    private var wasOffline = false
    private var allHeroes: [Character] = []
    private var lastRequestedId: Int?
    private var hasLoaded = false
    
    init(
        fetchHeroesUseCase: FetchCharactersUseCaseProtocol,
        networkMonitor: NetworkMonitoringProtocol
    ) {
        self.fetchHeroesUseCase = fetchHeroesUseCase
        self.networkMonitor = networkMonitor
        observeNetwork()
        observeSearchText()
    }
    
    private func observeNetwork() {
        networkMonitor.isConnectedPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.handleNetworkChange(isConnected: isConnected)
            }
            .store(in: &cancellables)
    }
    
    private func observeSearchText() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterHeroes()
            }
            .store(in: &cancellables)
    }
    
    func initialLoad() async {
        guard !hasLoaded else { return }
        
        if networkMonitor.isConnected {
            await fetchHeroes()
        } else {
            loadCachedHeroes()
        }
        hasLoaded = true
    }
    
    func loadMoreIfNeeded(currentItem: HeroCellViewModel) {
        guard let last = heroCellViewModels.last else { return }
        guard currentItem.id == last.id, currentItem.id != lastRequestedId else { return }
        
        lastRequestedId = currentItem.id
        Task { await fetchHeroes() }
    }
    
    func fetchHeroes(resetBeforeFetch: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        
        if resetBeforeFetch {
            resetState()
        }
        
        do {
            let characters = try await fetchHeroesUseCase.execute(offset: currentOffset)
            
            if characters.isEmpty {
                isLoading = false
                return
            }
            
            currentOffset += characters.count
            
            let uniqueNew = characters.filter { new in
                !allHeroes.contains(where: { $0.id == new.id })
            }
            
            allHeroes += uniqueNew
            filterHeroes()
            try await fetchHeroesUseCase.save(characters: allHeroes)
        } catch {
            if allHeroes.isEmpty {
                loadCachedHeroes()
            }
        }
        
        isLoading = false
    }
    
    func filterHeroes() {
        let currentText = searchText.lowercased()
        let characters = allHeroes
        
        Task {
            let filtered = currentText.isEmpty ? characters : characters.filter {
                $0.name.lowercased().contains(currentText)
            }
            let unique = Dictionary(grouping: filtered, by: \.id).compactMapValues(\.first).values.sorted {
                $0.name.lowercased() < $1.name.lowercased()
            }
            
            let viewModels = unique.map(HeroCellViewModel.init)
            
            await MainActor.run {
                self.heroCellViewModels = viewModels
            }
        }
    }
    
    private func loadCachedHeroes() {
        if let cached = try? fetchHeroesUseCase.fetchCachedHeroes(), allHeroes.isEmpty {
            allHeroes = cached
            filterHeroes()
            
            Task {
                try? await fetchHeroesUseCase.save(characters: allHeroes)
            }
        }
    }
    
    func persistCurrentListIfNeeded() {
        guard !allHeroes.isEmpty else { return }
        Task {
            try? await fetchHeroesUseCase.save(characters: allHeroes)
        }
    }
    
    private func handleNetworkChange(isConnected: Bool) {
        if isConnected {
            if wasOffline {
                
                Task { await fetchHeroes(resetBeforeFetch: true) }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                }
                
                wasOffline = false
            }
        } else {
            wasOffline = true
            persistCurrentListIfNeeded()
        }
    }
    
    private func resetState() {
        currentOffset = 0
        allHeroes = []
        heroCellViewModels = []
    }
}
