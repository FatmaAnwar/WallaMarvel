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
    
    private var allHeroes: [Character] = []
    private var currentOffset = 0
    private var isLoading = false
    private let heroesService: HeroesServiceProtocol
    
    init(heroesService: HeroesServiceProtocol = HeroesService()) {
        self.heroesService = heroesService
    }
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    func getHeroes() async {
        guard !isLoading else { return }
        isLoading = true
        delegate?.showLoading(true)
        
        do {
            let newHeroes = try await heroesService.fetchMore(offset: currentOffset)
            currentOffset += newHeroes.count
            
            let uniqueNew = newHeroes.filter { newHero in
                !allHeroes.contains(where: { $0.id == newHero.id })
            }
            
            allHeroes += uniqueNew
            delegate?.update(heroes: allHeroes.map { HeroCellViewModel(from: $0) })
            
            try await heroesService.save(characters: allHeroes)
        } catch {
            print("Error fetching heroes: \(error.localizedDescription)")
            loadCachedIfNeeded()
        }
        
        delegate?.showLoading(false)
        isLoading = false
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
            Task {
                await getHeroes()
            }
        }
    }
    
    private func loadCachedIfNeeded() {
        guard allHeroes.isEmpty else { return }
        
        if let cached = try? heroesService.fetchCachedHeroes() {
            allHeroes = cached
            delegate?.update(heroes: cached.map { HeroCellViewModel(from: $0) })
        }
    }
}
