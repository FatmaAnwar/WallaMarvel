//
//  CharacterMapperProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation
import WallaMarvelDomain

protocol CharacterMapperProtocol {
    func map(_ dtos: [CharacterDataModel]) -> [Character]
}
