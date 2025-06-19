//
//  HeroesListViewModelTests.swift
//  WallaMarvelTests
//
//  Created by Fatma Anwar on 19/06/2025.
//

import XCTest
import Combine
import WallaMarvelDomain
import WallaMarvelCore
@testable import WallaMarvelPresentation

@MainActor
final class HeroesListViewModelTests: XCTestCase {
    
    var sut: HeroesListViewModel!
    var mockUseCase: MockFetchCharactersUseCase!
    var mockNetwork: MockNetworkMonitor!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCharactersUseCase()
        mockNetwork = MockNetworkMonitor()
        mockNetwork.isConnected = true
        sut = HeroesListViewModel(fetchHeroesUseCase: mockUseCase, networkMonitor: mockNetwork)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockNetwork = nil
        cancellables = []
        super.tearDown()
    }
    
    func waitForHeroList(expectedCount: Int, timeout: TimeInterval = 1.0) async {
        let expectation = XCTestExpectation(description: "Wait for hero list")
        var cancellable: AnyCancellable?
        
        cancellable = sut.$heroCellViewModels
            .sink { viewModels in
                if viewModels.count == expectedCount {
                    expectation.fulfill()
                    cancellable?.cancel()
                }
            }
        
        await fulfillment(of: [expectation], timeout: timeout)
    }
    
    func test_initialLoad_whenOnline_fetchesAndDisplaysHeroes() async {
        // Given
        mockUseCase.stubbedCharacters = [Character(id: 1, name: "Iron Man", imageUrl: "", description: "")]
        
        // When
        await sut.initialLoad()
        await waitForHeroList(expectedCount: 1)
        
        // Then
        XCTAssertEqual(sut.heroCellViewModels.count, 1)
        XCTAssertEqual(sut.heroCellViewModels.first?.name, "Iron Man")
    }
    
    func test_initialLoad_whenOffline_loadsFromCache() async {
        // Given
        mockNetwork.isConnected = false
        mockUseCase.stubbedCachedCharacters = [Character(id: 2, name: "Thor", imageUrl: "", description: "")]
        
        // When
        await sut.initialLoad()
        await waitForHeroList(expectedCount: 1)
        
        // Then
        XCTAssertEqual(sut.heroCellViewModels.count, 1)
        XCTAssertEqual(sut.heroCellViewModels.first?.name, "Thor")
    }
    
    func test_filterHeroes_appliesSearchTextCorrectly() async {
        // Given
        mockUseCase.stubbedCharacters = [
            Character(id: 1, name: "Thor", imageUrl: "", description: ""),
            Character(id: 2, name: "Hulk", imageUrl: "", description: "")
        ]
        await sut.fetchHeroes()
        await waitForHeroList(expectedCount: 2)
        
        // When
        sut.searchText = "hulk"
        try? await Task.sleep(nanoseconds: 400_000_000) // debounce
        
        // Then
        XCTAssertEqual(sut.heroCellViewModels.count, 1)
        XCTAssertEqual(sut.heroCellViewModels.first?.name, "Hulk")
    }
    
    func test_fetchHeroes_appendsUniqueCharactersAndSaves() async {
        // Given
        mockUseCase.stubbedCharacters = [
            Character(id: 1, name: "Thor", imageUrl: "", description: ""),
            Character(id: 2, name: "Hulk", imageUrl: "", description: "")
        ]
        
        // When
        await sut.fetchHeroes()
        await waitForHeroList(expectedCount: 2)
        
        // Then
        XCTAssertEqual(sut.heroCellViewModels.count, 2)
        XCTAssertTrue(mockUseCase.saveCalled)
    }
    
    func test_fetchHeroes_whenEmpty_doesNotUpdateViewModels() async {
        // Given
        mockUseCase.stubbedCharacters = []
        
        // When
        await sut.fetchHeroes()
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        // Then
        XCTAssertTrue(sut.heroCellViewModels.isEmpty)
    }
    
    func test_fetchHeroes_failureFallback_loadsCached() async {
        // Given
        mockUseCase.shouldThrow = true
        mockUseCase.stubbedCachedCharacters = [
            Character(id: 3, name: "Spider-Man", imageUrl: "", description: "")
        ]
        
        // When
        await sut.fetchHeroes(resetBeforeFetch: true)
        await waitForHeroList(expectedCount: 1)
        
        // Then
        XCTAssertEqual(sut.heroCellViewModels.first?.name, "Spider-Man")
    }
    
    func test_persistCurrentListIfNeeded_savesIfNonEmpty() async {
        // Given
        mockUseCase.stubbedCharacters = [Character(id: 4, name: "Black Panther", imageUrl: "", description: "")]
        await sut.fetchHeroes()
        await waitForHeroList(expectedCount: 1)
        mockUseCase.saveCalled = false
        
        // When
        sut.persistCurrentListIfNeeded()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(mockUseCase.saveCalled)
    }
    
    func test_loadMoreIfNeeded_triggersFetchForLastItem() async {
        // Given
        let hero1 = Character(id: 1, name: "Hero1", imageUrl: "", description: "")
        let hero2 = Character(id: 2, name: "Hero2", imageUrl: "", description: "")
        mockUseCase.stubbedCharacters = [hero1]
        await sut.fetchHeroes()
        await waitForHeroList(expectedCount: 1)
        
        mockUseCase.stubbedCharacters = [hero1, hero2]
        guard let lastItem = sut.heroCellViewModels.last else {
            XCTFail("No last item")
            return
        }
        
        // When
        sut.loadMoreIfNeeded(currentItem: lastItem)
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Then
        XCTAssertTrue(sut.heroCellViewModels.contains { $0.name == "Hero2" })
    }
    
    func test_handleNetworkChange_whenWasOffline_fetchesAgain() async {
        // Given
        sut.wasOffline = true
        mockUseCase.stubbedCharacters = [Character(id: 10, name: "Loki", imageUrl: "", description: "")]
        
        // When
        sut.handleNetworkChange(isConnected: true)
        await waitForHeroList(expectedCount: 1)
        
        // Then
        XCTAssertEqual(sut.heroCellViewModels.first?.name, "Loki")
        XCTAssertFalse(sut.wasOffline)
    }
    
    func test_handleNetworkChange_whenGoesOffline_setsWasOfflineTrue() {
        // When
        sut.handleNetworkChange(isConnected: false)
        
        // Then
        XCTAssertTrue(sut.wasOffline)
    }
}
