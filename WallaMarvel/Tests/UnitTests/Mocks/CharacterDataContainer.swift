//
//  CharacterDataContainer.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
@testable import WallaMarvel

extension CharacterDataContainer {
    init(mockResults: [CharacterDataModel]) {
        self.init(
            count: mockResults.count,
            limit: 20,
            offset: 0,
            characters: mockResults
        )
    }
}
