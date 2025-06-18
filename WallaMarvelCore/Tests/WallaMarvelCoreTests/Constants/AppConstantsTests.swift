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
        // Given
        let expectedPublicKey = "d575c26d5c746f623518e753921ac847"
        let expectedPrivateKey = "188f9a5aa76846d907c41cbea6506e4cc455293f"
        let expectedBaseURL = "https://gateway.marvel.com:443/v1/public"
        let expectedPath = "/characters"
        
        // When
        let publicKey = AppConstants.MarvelAPI.publicKey
        let privateKey = AppConstants.MarvelAPI.privateKey
        let baseURL = AppConstants.MarvelAPI.baseURL
        let path = AppConstants.MarvelAPI.charactersPath
        
        // Then
        XCTAssertEqual(publicKey, expectedPublicKey)
        XCTAssertEqual(privateKey, expectedPrivateKey)
        XCTAssertEqual(baseURL, expectedBaseURL)
        XCTAssertEqual(path, expectedPath)
    }
}
