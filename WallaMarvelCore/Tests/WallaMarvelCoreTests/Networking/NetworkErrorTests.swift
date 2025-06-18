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
        let _ = NetworkError.invalidURL
        let _ = NetworkError.noData
        let _ = NetworkError.decodingError
    }
}
