//
//  HeroesListViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class HeroesListViewModel: ObservableObject {
    @Published var heroCellViewModels: [SwiftUIHeroCellViewModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var showOfflineBanner: Bool = false
    @Published var showOnlineToast: Bool = false
    
    private let fetchHeroesUseCase: FetchHeroesUseCaseProtocol
    private let networkMonitor: NetworkMonitor
    private let debounceDuration: TimeInterval = 0.4
    
    private var cancellables = Set<AnyCancellable>()
    private var currentOffset = 0
    private var wasOffline = false
    private var allHeroes: [Character] = []
    
    init(
        fetchHeroesUseCase: FetchHeroesUseCaseProtocol = FetchHeroesUseCase(),
        networkMonitor: NetworkMonitor = .shared
    ) {
        self.fetchHeroesUseCase = fetchHeroesUseCase
        self.networkMonitor = networkMonitor
        
        observeNetwork()
        observeSearchText()
    }
    
    private func observeNetwork() {
        networkMonitor.$isConnected
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.handleNetworkChange(isConnected: isConnected)
            }
            .store(in: &cancellables)
    }
    
    private func observeSearchText() {
        $searchText
            .debounce(for: .seconds(debounceDuration), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.filterHeroes()
            }
            .store(in: &cancellables)
    }
    
    func initialLoad() {
        if networkMonitor.isConnected {
            Task { await fetchHeroes() }
        } else {
            loadCachedHeroes()
            showOfflineBanner = true
        }
    }
    
    func loadMoreIfNeeded(currentItem: SwiftUIHeroCellViewModel) {
        guard let last = heroCellViewModels.last, currentItem.id == last.id else { return }
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
            currentOffset += characters.count
            
            let uniqueNew = characters.filter { new in
                !allHeroes.contains(where: { $0.id == new.id })
            }
            
            allHeroes += uniqueNew
            filterHeroes()
            try await fetchHeroesUseCase.save(characters: allHeroes)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            loadCachedHeroes()
        }
        
        isLoading = false
    }
    
    func filterHeroes() {
        let filtered: [Character] = searchText.isEmpty
        ? allHeroes
        : allHeroes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
        heroCellViewModels = filtered
            .reduce(into: [Character]()) { result, char in
                if !result.contains(where: { $0.id == char.id }) {
                    result.append(char)
                }
            }
            .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            .map(SwiftUIHeroCellViewModel.init)
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
                showOfflineBanner = false
                showOnlineToast = true
                
                Task { await fetchHeroes(resetBeforeFetch: true) }
                
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
    
    private func resetState() {
        currentOffset = 0
        allHeroes = []
        heroCellViewModels = []
    }
}
