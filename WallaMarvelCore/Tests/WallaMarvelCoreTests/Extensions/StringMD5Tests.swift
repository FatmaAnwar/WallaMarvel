//
//  StringMD5Tests.swift
//  WallaMarvelCore
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvelCore

final class StringMD5Tests: XCTestCase {
    func test_md5_returnsCorrectHash() {
        // Given
        let input = "test"
        let expectedHash = "098f6bcd4621d373cade4e832627b4f6"
        
        // When
        let hash = input.md5
        
        // Then
        XCTAssertEqual(hash, expectedHash)
    }
}
