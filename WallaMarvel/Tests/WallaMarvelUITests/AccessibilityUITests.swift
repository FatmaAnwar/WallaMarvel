//
//  AccessibilityUITests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
import XCTest

final class AccessibilityUITests: XCTestCase {
    func test_AccessibilityIdentifiersAreSet() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.staticTexts["heroListTitle"].waitForExistence(timeout: 3), "List title should be present.")
        XCTAssertTrue(app.textFields["searchTextField"].waitForExistence(timeout: 3), "Search field should be present.")
        
        let cell = app.buttons.containing(NSPredicate(format: "identifier BEGINSWITH %@", "heroCell_")).firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 3), "Hero cell with accessibility identifier should be present.")
    }
}
