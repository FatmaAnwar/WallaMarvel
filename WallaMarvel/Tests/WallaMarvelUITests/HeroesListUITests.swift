//
//  HeroesListUITests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
import XCTest

final class HeroesListUITests: XCTestCase {
    func test_HeroesList_displayAndTapFirstCell() {
        let app = XCUIApplication()
        app.launch()
        
        let title = app.staticTexts["heroListTitle"]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        
        let firstCell = app.buttons.containing(NSPredicate(format: "identifier BEGINSWITH %@", "heroCell_")).firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "First hero cell should exist.")
        firstCell.tap()
        
        let detailName = app.staticTexts["heroDetailName"]
        XCTAssertTrue(detailName.waitForExistence(timeout: 5), "Detail screen should appear after tap.")
    }
}
