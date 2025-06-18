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
        XCTAssertEqual(String.accHeroImage(name: "Hulk"), "Image of Hulk")
        XCTAssertEqual(String.accHeroCell(name: "Iron Man"), "Hero: Iron Man")
        XCTAssertEqual(String.accHeroDetailLabel(name: "Thor"), "Hero name: Thor")
        XCTAssertEqual(String.accHeroDescription(text: "Avenger"), "Hero description: Avenger")
        XCTAssertEqual(String.accHeroImageUnavailable(name: "Spider-Man"), "No image available for Spider-Man")
    }
}
