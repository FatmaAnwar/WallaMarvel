//
//  EmptyStateUITests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
import XCTest

final class EmptyStateUITests: XCTestCase {
    func test_EmptySearchShowsNoResults() {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search field should be present.")
        searchField.tap()
        searchField.typeText("asdjfalksdfjlaksjdflk")
        
        sleep(1)
        
        let resultCell = app.buttons.containing(NSPredicate(format: "identifier BEGINSWITH %@", "heroCell_")).firstMatch
        XCTAssertFalse(resultCell.exists, "No hero cell should appear for a nonsense search.")
    }
}
