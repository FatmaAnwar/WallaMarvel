//
//  ListHeroesViewModelTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvel

final class ListHeroesViewModelTests: XCTestCase {

    private var viewModel: ListHeroesViewModel!
    private var mockUseCase: MockFetchHeroesUseCase!
    private var delegate: MockListHeroesDelegate!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchHeroesUseCase()
        delegate = MockListHeroesDelegate()
        viewModel = ListHeroesViewModel(getHeroesUseCase: mockUseCase)
        viewModel.delegate = delegate
    }

    func test_screenTitle_returnsExpectedValue() {
        // When
        let title = viewModel.screenTitle()

        // Then
        XCTAssertEqual(title, "List of Heroes")
    }

    func test_getHeroes_fetchesDataAndUpdatesDelegate() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Spider-Man", imageUrl: "", description: "Superhero")
        ]

        // When
        await viewModel.getHeroes()

        // Then
        XCTAssertTrue(delegate.loadingStates.first == true)
        XCTAssertEqual(delegate.heroes.count, 1)
        XCTAssertEqual(delegate.heroes.first?.name, "Spider-Man")
    }

    func test_getHeroes_doesNotDuplicateCharacters() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Spider-Man", imageUrl: "", description: ""),
            Character(id: 1, name: "Spider-Man", imageUrl: "", description: "")
        ]

        // When
        await viewModel.getHeroes()

        // Then
        XCTAssertEqual(delegate.heroes.count, 1)
    }

    func test_searchHeroes_filtersResultsCorrectly() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Iron Man", imageUrl: "", description: ""),
            Character(id: 2, name: "Hulk", imageUrl: "", description: "")
        ]
        await viewModel.getHeroes()

        // When
        viewModel.searchHeroes(with: "hulk")

        // Then
        XCTAssertEqual(delegate.heroes.count, 1)
        XCTAssertEqual(delegate.heroes.first?.name.lowercased(), "hulk")
    }

    func test_searchHeroes_withEmptyQueryReturnsAll() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Iron Man", imageUrl: "", description: ""),
            Character(id: 2, name: "Hulk", imageUrl: "", description: "")
        ]
        await viewModel.getHeroes()

        // When
        viewModel.searchHeroes(with: "")

        // Then
        XCTAssertEqual(delegate.heroes.count, 2)
    }

    func test_didScrollToBottom_triggersFetch() async {
        // Given
        let mockUseCase = MockFetchHeroesUseCase()
        let viewModel = ListHeroesViewModel(getHeroesUseCase: mockUseCase, cacheRepository: MockCharacterCacheRepository())

        // When
        viewModel.didScrollToBottom(currentOffsetY: 900, contentHeight: 1000, scrollViewHeight: 100)
        try? await Task.sleep(nanoseconds: 300_000_000)

        // Then
        XCTAssertTrue(mockUseCase.didExecute)
    }

    func test_getHeroes_doesNotFetchIfAlreadyLoading() async {
        // Given
        viewModel.isLoading = true

        // When
        await viewModel.getHeroes()

        // Then
        XCTAssertFalse(mockUseCase.didExecute)
    }
}
