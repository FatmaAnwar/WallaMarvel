//
//  NetworkErrorTests.swift
//  WallaMarvelCore
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvelCore

final class NetworkErrorTests: XCTestCase {
    func test_networkError_enumCasesExist() {
        // Given & When
        let error1 = NetworkError.invalidURL
        let error2 = NetworkError.noData
        let error3 = NetworkError.decodingError
        
        // Then
        XCTAssertNotNil(error1)
        XCTAssertNotNil(error2)
        XCTAssertNotNil(error3)
    }
}
