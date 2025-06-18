//
//  MarvelAPIClientProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

public protocol MarvelAPIClientProtocol {
    func getHeroes(offset: Int) async throws -> CharacterDataContainer
}
