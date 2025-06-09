//
//  MarvelRemoteDataSourceProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

protocol MarvelRemoteDataSourceProtocol {
    func getHeroes(offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void)
}
