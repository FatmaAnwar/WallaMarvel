//
//  ListHeroesViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import UIKit

final class ListHeroesViewModel: ListHeroesViewModelProtocol {
    weak var delegate: ListHeroesViewModelDelegate?

    private let getHeroesUseCase: FetchHeroesUseCaseProtocol
    private let cacheRepository: CharacterCacheRepositoryProtocol

    private var allHeroes: [Character] = []
    private var currentOffset = 0
    private var isLoading = false

    init(
        getHeroesUseCase: FetchHeroesUseCaseProtocol = FetchHeroesUseCase(),
        cacheRepository: CharacterCacheRepositoryProtocol = CharacterCacheRepository()
    ) {
        self.getHeroesUseCase = getHeroesUseCase
        self.cacheRepository = cacheRepository
    }

    func screenTitle() -> String {
        "List of Heroes"
    }

    func getHeroes() async {
        guard !isLoading else { return }
        isLoading = true
        delegate?.showLoading(true)

        do {
            let newHeroes = try await getHeroesUseCase.execute(offset: currentOffset)
            currentOffset += newHeroes.count

            let uniqueNew = newHeroes.filter { newChar in
                !allHeroes.contains(where: { $0.id == newChar.id })
            }

            allHeroes += uniqueNew
            delegate?.update(heroes: allHeroes.map { HeroCellViewModel(from: $0) })

            try await getHeroesUseCase.save(characters: allHeroes)
        } catch {
            print("Error: \(error)")
            loadFromCacheIfNeeded()
        }

        isLoading = false
        delegate?.showLoading(false)
    }

    func searchHeroes(with text: String) {
        let filtered = text.isEmpty
        ? allHeroes
        : allHeroes.filter { $0.name.lowercased().contains(text.lowercased()) }

        delegate?.update(heroes: filtered.map { HeroCellViewModel(from: $0) })
    }

    func didScrollToBottom(currentOffsetY: CGFloat, contentHeight: CGFloat, scrollViewHeight: CGFloat) {
        let threshold: CGFloat = 100.0
        if currentOffsetY > (contentHeight - scrollViewHeight - threshold) {
            Task { await getHeroes() }
        }
    }

    private func loadFromCacheIfNeeded() {
        if allHeroes.isEmpty {
            if let cached = try? cacheRepository.fetchCachedHeroes() {
                allHeroes = cached
                delegate?.update(heroes: cached.map { HeroCellViewModel(from: $0) })
            }
        }
    }
}
