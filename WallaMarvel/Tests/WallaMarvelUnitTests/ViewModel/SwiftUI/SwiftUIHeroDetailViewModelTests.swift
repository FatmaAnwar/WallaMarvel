//
//  SwiftUIHeroDetailViewModelTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvel

final class SwiftUIHeroDetailViewModelTests: XCTestCase {
    
    func test_init_setsNameDescriptionAndImageURL() async {
        // Given
        let character = Character(
            id: 1,
            name: "Captain America",
            imageUrl: "https://example.com/cap.jpg",
            description: "Leader of the Avengers"
        )
        
        // When
        let viewModel = await MainActor.run {
            SwiftUIHeroDetailViewModel(character: character)
        }
        
        // Then
        let name = await MainActor.run { viewModel.name }
        let description = await MainActor.run { viewModel.description }
        let imageURL = await MainActor.run { viewModel.imageURL }
        
        XCTAssertEqual(name, "Captain America")
        XCTAssertEqual(description, "Leader of the Avengers")
        XCTAssertEqual(imageURL?.absoluteString, "https://example.com/cap.jpg")
    }
    
    func test_descriptionFallbacksToDefault_whenEmpty() async {
        // Given
        let character = Character(
            id: 2,
            name: "Vision",
            imageUrl: "",
            description: ""
        )
        
        // When
        let viewModel = await MainActor.run {
            SwiftUIHeroDetailViewModel(character: character)
        }
        
        // Then
        let description = await MainActor.run { viewModel.description }
        XCTAssertEqual(description, String.noDescription)
    }
    
    func test_imageURL_isNil_whenMalformedURL() async {
        // Given
        let character = Character(
            id: 3,
            name: "Loki",
            imageUrl: "ht^tp:/invalid",
            description: "God of Mischief"
        )
        
        // When
        let viewModel = await MainActor.run {
            SwiftUIHeroDetailViewModel(character: character)
        }
        
        // Then
        let imageURL = await MainActor.run { viewModel.imageURL }
        XCTAssertNil(imageURL)
    }
    
    func test_description_withWhitespaceOnly_returnsFallback() async {
        let character = Character(
            id: 4,
            name: "Ghost",
            imageUrl: "https://example.com/ghost.png",
            description: "    "
        )
        
        let viewModel = await MainActor.run {
            SwiftUIHeroDetailViewModel(character: character)
        }
        
        let description = await MainActor.run { viewModel.description }
        XCTAssertEqual(description, String.noDescription)
    }
    
    func test_imageURL_isNil_whenEmptyStringProvided() async {
        let character = Character(
            id: 5,
            name: "Falcon",
            imageUrl: "",
            description: "Sky Soldier"
        )
        
        let viewModel = await MainActor.run {
            SwiftUIHeroDetailViewModel(character: character)
        }
        
        let imageURL = await MainActor.run { viewModel.imageURL }
        XCTAssertNil(imageURL)
    }
}
