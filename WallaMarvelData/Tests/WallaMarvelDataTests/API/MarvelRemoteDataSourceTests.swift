//
//  File.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
import WallaMarvelCore
@testable import WallaMarvelData

@MainActor
final class MarvelRemoteDataSourceTests: XCTestCase {
    
    func test_fetchCharacters_returnsDTOsCorrectly() async throws { 
        // Given
        let mockClient = MockMarvelAPIClient()
        mockClient.stubbedCharacters = [
            CharacterDataModel(id: 1, name: "Cap", thumbnail: Thumbnail(path: "img", extension: "png"), description: "desc")
        ]
        let sut = MarvelRemoteDataSource(apiClient: mockClient)
        
        // When
        let result = try await sut.fetchCharacters(offset: 0)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Cap")
    }
    
    func test_fetchCharacters_whenClientThrows_shouldThrowError() async {
        // Given
        let mockClient = MockMarvelAPIClient()
        mockClient.shouldThrow = true
        let sut = MarvelRemoteDataSource(apiClient: mockClient)
        
        // When & Then
        do {
            _ = try await sut.fetchCharacters(offset: 0)
            XCTFail("Expected error to be thrown, but succeeded")
        } catch {
            XCTAssertEqual(error as? NetworkError, .decodingError)
        }
    }
    
    func test_fetchCharacters_whenResponseIsEmpty_shouldReturnEmptyArray() async throws {
        // Given
        let mockClient = MockMarvelAPIClient()
        mockClient.stubbedCharacters = []
        let sut = MarvelRemoteDataSource(apiClient: mockClient)
        
        // When
        let result = try await sut.fetchCharacters(offset: 0)
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_fetchCharacters_withMultipleResults_shouldReturnAll() async throws {
        // Given
        let mockClient = MockMarvelAPIClient()
        mockClient.stubbedCharacters = [
            CharacterDataModel(id: 1, name: "Cap", thumbnail: Thumbnail(path: "img1", extension: "png"), description: "desc1"),
            CharacterDataModel(id: 2, name: "Iron Man", thumbnail: Thumbnail(path: "img2", extension: "jpg"), description: "desc2")
        ]
        let sut = MarvelRemoteDataSource(apiClient: mockClient)
        
        // When
        let result = try await sut.fetchCharacters(offset: 0)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.map(\.name), ["Cap", "Iron Man"])
    }
    
    func test_fetchCharacters_passesCorrectOffsetToAPI() async throws {
        // Given
        let mockClient = MockMarvelAPIClient()
        let expectedOffset = 42
        let sut = MarvelRemoteDataSource(apiClient: mockClient)
        
        // When
        _ = try await sut.fetchCharacters(offset: expectedOffset)
        
        // Then
        XCTAssertEqual(mockClient.receivedOffset, expectedOffset)
    }
    
    func test_fetchCharacters_withMissingOptionalFields_shouldNotCrash() async throws {
        // Given
        let mockClient = MockMarvelAPIClient()
        mockClient.stubbedCharacters = [
            CharacterDataModel(id: 1, name: "Cap", thumbnail: Thumbnail(path: "img", extension: "png"), description: nil)
        ]
        let sut = MarvelRemoteDataSource(apiClient: mockClient)
        
        // When
        let result = try await sut.fetchCharacters(offset: 0)
        
        // Then
        XCTAssertEqual(result.first?.description ?? "", "")
    }
}

