//
//  AppConstantsTests.swift
//  WallaMarvelCore
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvelCore

final class AppConstantsTests: XCTestCase {
    func test_marvelAPIConstants_areSetCorrectly() {
        XCTAssertEqual(AppConstants.MarvelAPI.publicKey, "d575c26d5c746f623518e753921ac847")
        XCTAssertEqual(AppConstants.MarvelAPI.privateKey, "188f9a5aa76846d907c41cbea6506e4cc455293f")
        XCTAssertEqual(AppConstants.MarvelAPI.baseURL, "https://gateway.marvel.com:443/v1/public")
        XCTAssertEqual(AppConstants.MarvelAPI.charactersPath, "/characters")
    }
}
