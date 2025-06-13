//
//  FetchHeroesUseCaseProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation

protocol FetchHeroesUseCaseProtocol {
    func execute(offset: Int) async throws -> [Character]
    func save(characters: [Character]) async throws
    func fetchCachedHeroes() throws -> [Character]
}
