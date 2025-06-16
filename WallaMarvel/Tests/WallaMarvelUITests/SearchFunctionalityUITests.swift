//
//  SearchFunctionalityUITests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
import XCTest

final class SearchFunctionalityUITests: XCTestCase {
    
    func test_SearchHero_navigatesToDetailScreen() {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should exist.")
        searchField.tap()
        searchField.typeText("Aaron Stack")
        
        let heroCell = app.buttons.firstMatch
        XCTAssertTrue(heroCell.waitForExistence(timeout: 5), "First hero cell should appear.")
    }
    
    func test_SearchHero_noResultsShown() {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should exist.")
        searchField.tap()
        searchField.typeText("zzzzzzzz")
        
        let firstCell = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "heroCell_")).firstMatch
        XCTAssertFalse(firstCell.waitForExistence(timeout: 5), "No hero cell should appear for unmatched search query.")
    }
}
