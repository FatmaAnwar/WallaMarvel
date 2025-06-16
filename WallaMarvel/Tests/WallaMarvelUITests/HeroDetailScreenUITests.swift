//
//  HeroDetailScreenUITests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
import XCTest

final class HeroDetailScreenUITests: XCTestCase {
    func test_HeroDetail_displaysNameAndDescription() {
        let app = XCUIApplication()
        app.launch()
        
        let firstCell = app.buttons.containing(NSPredicate(format: "identifier BEGINSWITH %@", "heroCell_")).firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "First hero cell should appear.")
        firstCell.tap()
        
        let name = app.staticTexts["heroDetailName"]
        let desc = app.staticTexts["heroDetailDescription"]
        
        XCTAssertTrue(name.waitForExistence(timeout: 5), "Hero name should appear on detail screen.")
        XCTAssertTrue(desc.waitForExistence(timeout: 5), "Hero description should appear on detail screen.")
    }
}
