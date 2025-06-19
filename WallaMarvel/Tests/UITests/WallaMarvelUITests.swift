//
//  WallaMarvelUITests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 19/06/2025.
//

import XCTest

final class WallaMarvelUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func test_heroTitleLabelAppears() {
        // Given
        let title = app.staticTexts["heroListTitle"]
        
        // Then
        XCTAssertTrue(title.waitForExistence(timeout: 5), "Hero list title should appear")
    }
    
    func test_searchTextFieldExists() {
        // Given
        let searchField = app.textFields["searchTextField"]
        
        // Then
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search text field should exist and be visible")
    }
    
    func test_searchFieldExistsAndAcceptsText() {
        // Given
        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should appear")
        
        // When
        searchField.tap()
        searchField.typeText("Iron")
        
        // Then
        XCTAssertEqual(searchField.value as? String, "Iron", "Search field should contain typed text")
    }
    
    func test_searchHeroes_filtersResults() {
        // Given
        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should exist")
        
        // When
        searchField.tap()
        searchField.typeText("3-D Man")
        
        // Then
        let expectedHero = app.staticTexts["3-D Man"]
        XCTAssertTrue(expectedHero.waitForExistence(timeout: 5), "Filtered result '3-D Man' should appear")
    }
    
    func test_loadingIndicatorAppears() {
        // Given
        let loader = app.otherElements["loadingIndicator"]
        
        // Then
        XCTAssertFalse(loader.exists, "Loading indicator should not be visible after loading completes")
    }
}
