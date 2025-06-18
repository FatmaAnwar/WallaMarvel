//
//  MarvelRemoteDataSourceProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

@MainActor
public protocol MarvelRemoteDataSourceProtocol {
    func fetchCharacters(offset: Int) async throws -> [CharacterDataModel]
}
