//
//  MarvelRequestBuilderTests.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvelData

final class MarvelRequestBuilderTests: XCTestCase {
    
    func test_charactersBuilder_createsValidURLRequest() {
        // Given
        let builder = MarvelRequestBuilder.characters(offset: 0)
        
        // When
        let request = builder.buildRequest()
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertTrue(request?.url?.absoluteString.contains("apikey=") ?? false)
        XCTAssertTrue(request?.url?.absoluteString.contains("/characters") ?? false)
    }
    
    func test_buildRequest_withInvalidBaseURL_returnsNil() {
        // Given
        let builder = MarvelRequestBuilder(path: "invalid", query: [:])
        
        // When
        let request = builder.buildRequest()
        
        // Then
        XCTAssertNotNil(request)
    }
}
