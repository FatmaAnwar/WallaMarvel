//
//  FetchCharactersUseCaseProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation

@MainActor
public protocol FetchCharactersUseCaseProtocol {
    func execute(offset: Int) async throws -> [Character]
    func fetchCachedHeroes() throws -> [Character]
    func save(characters: [Character]) async throws
}
