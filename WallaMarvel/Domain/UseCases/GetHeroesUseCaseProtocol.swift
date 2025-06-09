//
//  GetHeroesUseCaseProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

protocol GetHeroesUseCaseProtocol {
    func execute(offset: Int, completionBlock: @escaping (Result<[Character], Error>) -> Void)
}
