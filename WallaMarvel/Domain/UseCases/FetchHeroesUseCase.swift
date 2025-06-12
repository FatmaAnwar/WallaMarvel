//
//  FetchHeroesUseCase.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation

protocol FetchHeroesUseCaseProtocol {
    func fetch(offset: Int) async throws -> [Character]
}

final class FetchHeroesUseCase: FetchHeroesUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol

    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }

    func fetch(offset: Int) async throws -> [Character] {
        try await repository.getHeroes(offset: offset)
    }
}
