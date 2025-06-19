//
//  CharacterMapperTests.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
import WallaMarvelDomain
@testable import WallaMarvelData

final class CharacterMapperTests: XCTestCase {
    
    var mapper: CharacterMapper!
    
    override func setUp() {
        super.setUp()
        mapper = CharacterMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    func test_map_whenGivenValidDTOs_shouldReturnMappedDomainModels() {
        // Given
        let dto1 = CharacterDataModel(
            id: 1,
            name: "Iron Man",
            thumbnail: Thumbnail(path: "https://img.marvel.com/ironman", extension: "jpg"),
            description: "A billionaire in a suit"
        )
        let dto2 = CharacterDataModel(
            id: 2,
            name: "Thor",
            thumbnail: Thumbnail(path: "https://img.marvel.com/thor", extension: "png"),
            description: nil
        )
        let dtos = [dto1, dto2]
        
        // When
        let characters = mapper.map(dtos)
        
        // Then
        XCTAssertEqual(characters.count, 2)
        XCTAssertEqual(characters[0].id, 1)
        XCTAssertEqual(characters[0].name, "Iron Man")
        XCTAssertEqual(characters[0].imageUrl, "https://img.marvel.com/ironman.jpg")
        XCTAssertEqual(characters[0].description, "A billionaire in a suit")
        
        XCTAssertEqual(characters[1].id, 2)
        XCTAssertEqual(characters[1].name, "Thor")
        XCTAssertEqual(characters[1].imageUrl, "https://img.marvel.com/thor.png")
        XCTAssertEqual(characters[1].description, "")
    }
    
    func test_map_whenEmptyList_shouldReturnEmptyList() {
        // Given
        let emptyDTOs: [CharacterDataModel] = []
        
        // When
        let characters = mapper.map(emptyDTOs)
        
        // Then
        XCTAssertTrue(characters.isEmpty)
    }
    
    func test_map_whenThumbnailPathIsEmpty_shouldReturnCorrectImageUrl() {
        // Given
        let dto = CharacterDataModel(
            id: 3,
            name: "EmptyPath",
            thumbnail: Thumbnail(path: "", extension: "jpg"),
            description: nil
        )
        
        // When
        let characters = mapper.map([dto])
        
        // Then
        XCTAssertEqual(characters[0].imageUrl, ".jpg")
    }
    
    func test_map_whenNameIsEmpty_shouldMapAsIs() {
        // Given
        let dto = CharacterDataModel(
            id: 4,
            name: "",
            thumbnail: Thumbnail(path: "https://img", extension: "png"),
            description: "Nameless"
        )
        
        // When
        let characters = mapper.map([dto])
        
        // Then
        XCTAssertEqual(characters[0].name, "")
        XCTAssertEqual(characters[0].description, "Nameless")
    }
    
    func test_map_whenSpecialCharactersInFields_shouldNotCrash() {
        // Given
        let dto = CharacterDataModel(
            id: 5,
            name: "Spëçïål",
            thumbnail: Thumbnail(path: "https://img.com/spécial", extension: "jpeg"),
            description: "Spëçïål description"
        )
        
        // When
        let characters = mapper.map([dto])
        
        // Then
        XCTAssertEqual(characters[0].name, "Spëçïål")
        XCTAssertEqual(characters[0].imageUrl, "https://img.com/spécial.jpeg")
        XCTAssertEqual(characters[0].description, "Spëçïål description")
    }
    
    func test_map_whenDuplicateCharacters_shouldAllBeMappedIndividually() {
        // Given
        let dto = CharacterDataModel(
            id: 6,
            name: "Duplicate",
            thumbnail: Thumbnail(path: "path", extension: "jpg"),
            description: "copy"
        )
        
        // When
        let characters = mapper.map([dto, dto, dto])
        
        // Then
        XCTAssertEqual(characters.count, 3)
        XCTAssertTrue(characters.allSatisfy { $0.name == "Duplicate" })
    }
    
    func test_map_whenLongDescription_shouldBeMappedCompletely() {
        // Given
        let longDesc = String(repeating: "Marvel ", count: 100)
        let dto = CharacterDataModel(
            id: 7,
            name: "LongDesc",
            thumbnail: Thumbnail(path: "path", extension: "png"),
            description: longDesc
        )
        
        // When
        let characters = mapper.map([dto])
        
        // Then
        XCTAssertEqual(characters[0].description, longDesc)
    }
}
