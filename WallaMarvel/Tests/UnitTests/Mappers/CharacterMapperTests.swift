//
//  CharacterMapperTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvel

final class CharacterMapperTests: XCTestCase {
    
    private var mapper: CharacterMapper!
    
    override func setUp() {
        super.setUp()
        mapper = CharacterMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    func test_map_transformsDTOsToDomainModelsCorrectly() {
        // Given
        let dtoList = [
            CharacterDataModel(
                id: 101,
                name: "Captain Marvel",
                thumbnail: Thumbnail(path: "image/path", extension: "jpg"),
                description: "A powerful Avenger"
            )
        ]
        
        // When
        let result = mapper.map(dtoList)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, 101)
        XCTAssertEqual(result.first?.name, "Captain Marvel")
        XCTAssertEqual(result.first?.imageUrl, "image/path.jpg")
        XCTAssertEqual(result.first?.description, "A powerful Avenger")
    }
    
    func test_map_handlesEmptyList() {
        // Given
        let dtoList: [CharacterDataModel] = []
        
        // When
        let result = mapper.map(dtoList)
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_map_handlesMissingDescriptionGracefully() {
        // Given
        let dtoList = [
            CharacterDataModel(
                id: 102,
                name: "Vision",
                thumbnail: Thumbnail(path: "img/vision", extension: "png"),
                description: nil
            )
        ]
        
        // When
        let result = mapper.map(dtoList)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.description, "")
    }
    
    func test_map_handlesEmptyThumbnailValues() {
        // Given
        let dtoList = [
            CharacterDataModel(
                id: 103,
                name: "Black Panther",
                thumbnail: Thumbnail(path: "", extension: ""),
                description: "King of Wakanda"
            )
        ]
        
        // When
        let result = mapper.map(dtoList)
        
        // Then
        XCTAssertEqual(result.first?.imageUrl, ".")
    }
}
