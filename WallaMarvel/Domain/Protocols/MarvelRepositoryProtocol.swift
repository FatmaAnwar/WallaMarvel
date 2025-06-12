//
//  MarvelRepositoryProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

protocol MarvelRepositoryProtocol {
    func getHeroes(offset: Int) async throws -> [Character]
}
