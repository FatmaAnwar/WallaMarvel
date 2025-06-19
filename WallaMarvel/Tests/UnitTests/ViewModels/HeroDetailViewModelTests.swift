//
//  HeroDetailViewModelTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 19/06/2025.
//

import XCTest
import Combine
@testable import WallaMarvelPresentation
import WallaMarvelDomain

@MainActor
final class HeroDetailViewModelTests: XCTestCase {
    
    func test_initialState_loadsCorrectValues() {
        // Given
        let character = Character(
            id: 1,
            name: "Iron Man",
            imageUrl: "https://img.com/ironman.jpg",
            description: "Genius billionaire"
        )
        
        // When
        let viewModel = HeroDetailViewModel(character: character)
        
        // Then
        XCTAssertEqual(viewModel.name, "Iron Man")
        XCTAssertEqual(viewModel.description, "Genius billionaire")
        XCTAssertEqual(viewModel.imageURL?.absoluteString, "https://img.com/ironman.jpg")
    }
    
    func test_description_whenEmptyOrWhitespace_returnsNoDescriptionString() {
        // Given
        let emptyDescriptionCharacter = Character(
            id: 2,
            name: "NoDesc",
            imageUrl: "https://img.com/nodesc.jpg",
            description: "   \n  "
        )
        
        // When
        let viewModel = HeroDetailViewModel(character: emptyDescriptionCharacter)
        
        // Then
        XCTAssertEqual(viewModel.description, String.noDescription)
    }
    
    func test_imageURL_returnsNil_forInvalidURL() {
        // Given
        let invalidURLCharacter = Character(
            id: 3,
            name: "InvalidURL",
            imageUrl: "invalid_url",
            description: "Test"
        )
        
        // When
        let viewModel = HeroDetailViewModel(character: invalidURLCharacter)
        
        // Then
        XCTAssertNil(viewModel.imageURL)
    }
}
