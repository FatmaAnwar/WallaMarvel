//
//  CharacterRepositoryTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 14/06/2025.
//

import XCTest
@testable import WallaMarvel

final class CharacterRepositoryTests: XCTestCase {

    private var repository: CharacterRepository!
    private var mockDataSource: MockRemoteDataSource!
    private var mockCache: MockCharacterCacheRepository!
    private var mockMapper: MockCharacterMapper!

    override func setUp() {
        super.setUp()
        mockDataSource = MockRemoteDataSource()
        mockCache = MockCharacterCacheRepository()
        mockMapper = MockCharacterMapper()
        repository = CharacterRepository(
            remoteDataSource: mockDataSource,
            cacheRepository: mockCache,
            characterMapper: mockMapper
        )
    }

    override func tearDown() {
        repository = nil
        mockDataSource = nil
        mockCache = nil
        mockMapper = nil
        super.tearDown()
    }

    func test_fetchCharacters_successfulResponse_returnsMappedCharacters() async throws {
        // Given
        let dtos = [CharacterDataModel(id: 1, name: "Thor", thumbnail: .init(path: "", extension: ""), description: "God of Thunder")]
        mockDataSource.mockCharacters = dtos
        mockMapper.expectedMappedCharacters = [Character(id: 1, name: "Thor", imageUrl: "", description: "God of Thunder")]

        // When
        let result = try await repository.fetchCharacters(offset: 0)

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Thor")
    }

    func test_fetchCharacters_emptyResponse_returnsEmptyList() async throws {
        // Given
        mockDataSource.mockCharacters = []
        mockMapper.expectedMappedCharacters = []

        // When
        let result = try await repository.fetchCharacters(offset: 0)

        // Then
        XCTAssertTrue(result.isEmpty)
    }

    func test_fetchCharacters_whenDataSourceThrows_throwsURLError() async {
        // Given
        mockDataSource.shouldThrow = true
        mockDataSource.errorToThrow = URLError(.notConnectedToInternet)

        // When & Then
        do {
            _ = try await repository.fetchCharacters(offset: 0)
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }

    func test_fetchCachedHeroes_returnsCachedCharacters() throws {
        // Given
        let expected = [Character(id: 2, name: "Iron Man", imageUrl: "", description: "Genius Billionaire")]
        mockCache.cachedCharacters = expected

        // When
        let result = try repository.fetchCachedHeroes()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Iron Man")
    }

    func test_fetchCachedHeroes_emptyCache_returnsEmptyList() throws {
        // Given
        mockCache.cachedCharacters = []

        // When
        let result = try repository.fetchCachedHeroes()

        // Then
        XCTAssertTrue(result.isEmpty)
    }

    func test_fetchCachedHeroes_whenCacheThrows_throwsURLError() {
        // Given
        mockCache.shouldThrow = true

        // Then
        XCTAssertThrowsError(try repository.fetchCachedHeroes())
    }

    func test_saveCharacters_savesSuccessfully() async throws {
        // Given
        let characters = [Character(id: 3, name: "Hulk", imageUrl: "", description: "Smash")]

        // When
        try await repository.save(characters: characters)

        // Then
        XCTAssertEqual(mockCache.savedCharacters.count, 1)
        XCTAssertEqual(mockCache.savedCharacters.first?.name, "Hulk")
    }

    func test_saveCharacters_emptyList_savesWithoutCrash() async throws {
        // Given
        let characters: [Character] = []

        // When
        try await repository.save(characters: characters)

        // Then
        XCTAssertTrue(mockCache.savedCharacters.isEmpty)
    }

    func test_saveCharacters_whenCacheThrows_throwsURLError() async {
        // Given
        mockCache.shouldThrow = true
        let characters = [Character(id: 4, name: "Black Widow", imageUrl: "", description: "Spy")]

        // When & Then
        do {
            try await repository.save(characters: characters)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as? URLError)?.code, .cannotCreateFile)
        }
    }
}
