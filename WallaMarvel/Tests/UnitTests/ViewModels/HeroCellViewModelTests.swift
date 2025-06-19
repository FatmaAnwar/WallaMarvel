//
//  HeroCellViewModelTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 19/06/2025.
//

import XCTest
import WallaMarvelDomain
@testable import WallaMarvelPresentation

final class HeroCellViewModelTests: XCTestCase {
    
    func test_properties_returnExpectedValues() {
        // Given
        let character = Character(
            id: 42,
            name: "Spider-Man",
            imageUrl: "https://img.com/spiderman.jpg",
            description: "Friendly neighborhood hero"
        )
        let vm = HeroCellViewModel(character: character)
        
        // When
        let id = vm.id
        let name = vm.name
        let imageURL = vm.imageURL?.absoluteString
        
        // Then
        XCTAssertEqual(id, 42)
        XCTAssertEqual(name, "Spider-Man")
        XCTAssertEqual(imageURL, "https://img.com/spiderman.jpg")
    }
    
    func test_imageURL_returnsNil_forInvalidURL() {
        // Given
        let character = Character(
            id: 1,
            name: "Invalid",
            imageUrl: "not_a_url",
            description: ""
        )
        let vm = HeroCellViewModel(character: character)
        
        // When
        let imageURL = vm.imageURL
        
        // Then
        XCTAssertNil(imageURL)
    }
    
    func test_equality_comparison() {
        // Given
        let char1 = Character(id: 1, name: "Char1", imageUrl: "", description: "")
        let char2 = Character(id: 2, name: "Char2", imageUrl: "", description: "")
        
        let vm1a = HeroCellViewModel(character: char1)
        let vm1b = HeroCellViewModel(character: char1)
        let vm2 = HeroCellViewModel(character: char2)
        
        // When & Then
        XCTAssertEqual(vm1a, vm1b)
        XCTAssertNotEqual(vm1a, vm2)
    }
}
