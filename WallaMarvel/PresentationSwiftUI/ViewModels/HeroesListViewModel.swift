//
//  HeroesListViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class HeroesListViewModel: ObservableObject {
    @Published var heroCellViewModels: [SwiftUIHeroCellViewModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false

    @Published var showOfflineBanner: Bool = false
    @Published var showOnlineToast: Bool = false

    private var currentOffset = 0
    private var allHeroes: [Character] = []
    private var wasOffline = false
    private var cancellables = Set<AnyCancellable>()

    private let fetchHeroesUseCase: FetchHeroesUseCaseProtocol
    private let networkMonitor: NetworkMonitor

    init(
        fetchHeroesUseCase: FetchHeroesUseCaseProtocol = FetchHeroesUseCase(),
        networkMonitor: NetworkMonitor = .shared
    ) {
        self.fetchHeroesUseCase = fetchHeroesUseCase
        self.networkMonitor = networkMonitor

        observeNetwork()
    }

    private func observeNetwork() {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.handleNetworkChange(isConnected: isConnected)
            }
            .store(in: &cancellables)
    }

    private func handleNetworkChange(isConnected: Bool) {
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

    func initialLoad() {
        if networkMonitor.isConnected {
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
            let characters = try await fetchHeroesUseCase.execute(offset: currentOffset)
            currentOffset += characters.count

            let newUnique = characters.filter { newChar in
                !allHeroes.contains(where: { $0.id == newChar.id })
            }

            allHeroes += newUnique
            filterHeroes()

            try await fetchHeroesUseCase.save(characters: allHeroes)
        } catch {
            print("Error fetching heroes: \(error.localizedDescription)")
            loadFromCacheIfNeeded()
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentItem: SwiftUIHeroCellViewModel) {
        guard let lastItem = heroCellViewModels.last else { return }
        if currentItem.id == lastItem.id {
            Task { await getHeroes() }
        }
    }

    func filterHeroes() {
        let filtered: [Character] = searchText.isEmpty
            ? allHeroes
            : allHeroes.filter { $0.name.lowercased().contains(searchText.lowercased()) }

        let uniqueSorted = Dictionary(grouping: filtered, by: \.id)
            .compactMap { $0.value.first }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }

        heroCellViewModels = uniqueSorted.map { SwiftUIHeroCellViewModel(character: $0) }
    }

    private func preloadCachedHeroesIfAvailable() {
        guard allHeroes.isEmpty else { return }

        if let cached = try? fetchHeroesUseCase.fetchCachedHeroes() {
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

    private func loadFromCacheIfNeeded() {
        if allHeroes.isEmpty {
            if let cached = try? fetchHeroesUseCase.fetchCachedHeroes() {
                allHeroes = cached
                filterHeroes()
            }
        }
    }
}
