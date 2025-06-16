//
//  SwiftUIHeroCellViewModelTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvel

final class SwiftUIHeroCellViewModelTests: XCTestCase {
    
    func test_init_setsCorrectNameAndImageURL() {
        // Given
        let character = Character(
            id: 101,
            name: "Iron Man",
            imageUrl: "https://example.com/ironman.png",
            description: "Genius, billionaire, playboy, philanthropist"
        )
        
        // When
        let viewModel = SwiftUIHeroCellViewModel(character: character)
        
        // Then
        XCTAssertEqual(viewModel.name, "Iron Man")
        XCTAssertEqual(viewModel.imageURL?.absoluteString, "https://example.com/ironman.png")
        XCTAssertEqual(viewModel.id, 101)
    }
    
    func test_imageURL_isNilWhenInvalidURL() {
        // Given
        let character = Character(
            id: 102,
            name: "Hulk",
            imageUrl: "htt:p/badurl",
            description: "Green and angry"
        )
        
        // When
        let viewModel = SwiftUIHeroCellViewModel(character: character)
        
        // Then
        XCTAssertNil(viewModel.imageURL)
    }
}
