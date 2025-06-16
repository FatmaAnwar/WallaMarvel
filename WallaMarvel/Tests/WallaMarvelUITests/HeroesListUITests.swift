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
        XCTAssertTrue(title.waitForExistence(timeout: 5), "Hero list title should exist")
        
        let heroCell = app.buttons.firstMatch
        XCTAssertTrue(heroCell.waitForExistence(timeout: 5), "First hero cell should appear")
        
        heroCell.tap()
        
        let detailName = app.staticTexts["heroDetailName"]
        XCTAssertTrue(detailName.waitForExistence(timeout: 5), "Hero detail name should appear")
    }
}
