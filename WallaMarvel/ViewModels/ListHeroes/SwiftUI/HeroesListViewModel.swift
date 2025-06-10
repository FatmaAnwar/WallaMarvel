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
    private var currentOffset = 0
    private var allHeroes: [Character] = []

    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }

    func getHeroes() async {
        guard !isLoading else { return }
        isLoading = true

        do {
            let characters = try await getHeroesUseCase.execute(offset: currentOffset)
            currentOffset += characters.count
            allHeroes += characters
            filterHeroes()
        } catch {
            print("Error fetching heroes: \(error.localizedDescription)")
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
        if searchText.isEmpty {
            heroCellViewModels = allHeroes.map { HeroCellViewModel(from: $0) }
        } else {
            let filtered = allHeroes.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            heroCellViewModels = filtered.map { HeroCellViewModel(from: $0) }
        }
    }
}
