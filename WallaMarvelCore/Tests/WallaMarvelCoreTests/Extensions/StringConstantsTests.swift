//
//  StringConstantsTests.swift
//  WallaMarvelCore
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvelCore

final class StringConstantsTests: XCTestCase {
    func test_accessibilityTextBuilders_returnFormattedValues() {
        // Given
        let heroName = "Hulk"
        let heroDescription = "Avenger"
        
        // When
        let imageLabel = String.accHeroImage(name: heroName)
        let cellLabel = String.accHeroCell(name: "Iron Man")
        let detailLabel = String.accHeroDetailLabel(name: "Thor")
        let descLabel = String.accHeroDescription(text: heroDescription)
        let unavailableImageLabel = String.accHeroImageUnavailable(name: "Spider-Man")
        
        // Then
        XCTAssertEqual(imageLabel, "Image of Hulk")
        XCTAssertEqual(cellLabel, "Hero: Iron Man")
        XCTAssertEqual(detailLabel, "Hero name: Thor")
        XCTAssertEqual(descLabel, "Hero description: Avenger")
        XCTAssertEqual(unavailableImageLabel, "No image available for Spider-Man")
    }
}
