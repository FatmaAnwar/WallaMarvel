//
//  MarvelAPIClientTests.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
import WallaMarvelCore
@testable import WallaMarvelData

@MainActor
final class MarvelAPIClientTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        URLProtocol.registerClass(URLProtocolMock.self)
    }
    
    override class func tearDown() {
        URLProtocol.unregisterClass(URLProtocolMock.self)
        super.tearDown()
    }
    
    func test_getHeroes_whenValidResponse_shouldReturnCharacterDataContainer() async throws {
        // Given
        let mockJSON = """
        {
          "data": {
            "count": 1,
            "limit": 20,
            "offset": 0,
            "results": [
              {
                "id": 101,
                "name": "MockHero",
                "thumbnail": { "path": "path/to/image", "extension": "jpg" },
                "description": "Mock description"
              }
            ]
          }
        }
        """
        let data = mockJSON.data(using: .utf8)!
        URLProtocolMock.setTestData(data)
        
        let sut = MarvelAPIClient()
        
        // When
        let result = try await sut.getHeroes(offset: 0)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.characters.first?.id, 101)
        XCTAssertEqual(result.characters.first?.name, "MockHero")
    }
    
    func test_getHeroes_whenDecodingFails_shouldThrowDecodingError() async {
        // Given
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        URLProtocolMock.setTestData(invalidJSON)
        
        let sut = MarvelAPIClient()
        
        // When & Then
        do {
            _ = try await sut.getHeroes(offset: 0)
            XCTFail("Expected decoding error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_getHeroes_whenRequestFails_shouldThrowNetworkError() async {
        // Given
        URLProtocolMock.setTestError(URLError(.notConnectedToInternet))
        
        let sut = MarvelAPIClient()
        
        // When & Then
        do {
            _ = try await sut.getHeroes(offset: 0)
            XCTFail("Expected request failure")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
