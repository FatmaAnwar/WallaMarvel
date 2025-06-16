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
        XCTAssertTrue(searchField.exists, "Search field should exist.")
        searchField.tap()
        searchField.typeText("Aaron Stack")
        
        sleep(1)
        
        let heroCell = app.buttons.containing(NSPredicate(format: "identifier BEGINSWITH %@", "heroCell_")).firstMatch
        XCTAssertTrue(heroCell.waitForExistence(timeout: 3), "Hero cell should appear after searching.")
        heroCell.tap()
        
        let detailName = app.staticTexts["heroDetailName"]
        XCTAssertTrue(detailName.waitForExistence(timeout: 5), "Detail name should appear on detail screen.")
    }
    
    func test_SearchHero_noResultsShown() {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.exists, "Search field should exist.")
        searchField.tap()
        searchField.typeText("zzzzzzzz")
        
        sleep(1)
        
        let firstCell = app.buttons.containing(NSPredicate(format: "identifier BEGINSWITH %@", "heroCell_")).firstMatch
        XCTAssertFalse(firstCell.exists, "No hero cell should appear for unmatched search query.")
    }
}
