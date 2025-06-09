//
//  GetHeroes.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

struct GetHeroes: GetHeroesUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol

    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }

    func execute(offset: Int, completionBlock: @escaping (Result<[Character], Error>) -> Void) {
        Task {
            do {
                let characters = try await repository.getHeroes(offset: offset)
                completionBlock(.success(characters))
            } catch {
                completionBlock(.failure(error))
            }
        }
    }
}
