//
//  HeroCellViewModelTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvel

final class HeroCellViewModelTests: XCTestCase {
    
    func test_init_setsCorrectValues() {
        // Given
        let character = Character(
            id: 1,
            name: "Spider-Man",
            imageUrl: "https://example.com/spiderman.jpg",
            description: "Friendly neighborhood hero"
        )
        
        // When
        let viewModel = HeroCellViewModel(from: character)
        
        // Then
        XCTAssertEqual(viewModel.id, character.id)
        XCTAssertEqual(viewModel.name, character.name)
        XCTAssertEqual(viewModel.imageURL?.absoluteString, character.imageUrl)
        XCTAssertEqual(viewModel.originalHero.id, character.id)
    }
    
    func test_init_withInvalidURL_setsImageURLToNil() {
        // Given
        let character = Character(
            id: 2,
            name: "Invalid Hero",
            imageUrl: "ht!tp://bad[URL]",
            description: "Invalid URL"
        )
        
        // When
        let viewModel = HeroCellViewModel(from: character)
        
        // Then
        XCTAssertNil(viewModel.imageURL)
    }
    
    func test_init_withEmptyFields_stillInitializes() {
        // Given
        let character = Character(
            id: 3,
            name: "",
            imageUrl: "",
            description: ""
        )
        
        // When
        let viewModel = HeroCellViewModel(from: character)
        
        // Then
        XCTAssertEqual(viewModel.id, 3)
        XCTAssertEqual(viewModel.name, "")
        XCTAssertNil(viewModel.imageURL)
        XCTAssertEqual(viewModel.originalHero.description, "")
    }
}
