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
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func fetchMoreHeroes() async throws -> [HeroCellViewModel] {
        guard !isLoading else { return [] }
        isLoading = true
        defer { isLoading = false }
        
        let characters = try await getHeroesUseCase.execute(offset: currentOffset)
        currentOffset += characters.count
        allHeroes += characters
        
        return allHeroes.map { HeroCellViewModel(from: $0) }
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
