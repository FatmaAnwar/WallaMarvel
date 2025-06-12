//
//  CharacterCacheRepositoryProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation

protocol CharacterCacheRepositoryProtocol {
    func save(characters: [Character]) async throws
    func fetchCachedHeroes() throws -> [Character]
}
