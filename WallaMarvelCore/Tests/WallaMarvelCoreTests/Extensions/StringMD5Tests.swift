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
        let hash = "test".md5
        XCTAssertEqual(hash, "098f6bcd4621d373cade4e832627b4f6")
    }
}
