//
//  CharacterTests.swift
//  WallaMarvelDomain
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvelDomain

final class CharacterTests: XCTestCase {
    
    func test_characterEquatability_hashable() {
        // Given
        let char1 = Character(id: 1, name: "Spider-Man", imageUrl: "img1", description: "desc")
        let char2 = Character(id: 1, name: "Spider-Man", imageUrl: "img1", description: "desc")
        
        // When
        let areEqual = char1 == char2
        let uniqueSetCount = Set([char1, char2]).count
        
        // Then
        XCTAssertTrue(areEqual)
        XCTAssertEqual(uniqueSetCount, 1)
    }
    
    func test_character_sendableConformance() {
        // Given
        let char = Character(id: 1, name: "Iron Man", imageUrl: "url", description: "desc")
        
        // When & Then
        XCTAssertNoThrow({
            let _: @Sendable () -> Void = { _ = char }
        }())
    }
}
