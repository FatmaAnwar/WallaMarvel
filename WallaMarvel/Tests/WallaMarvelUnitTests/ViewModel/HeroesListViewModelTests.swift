//
//  HeroesListViewModelTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import XCTest
@testable import WallaMarvel

final class HeroesListViewModelTests: XCTestCase {
    
    private var mockUseCase: MockFetchHeroesUseCase!
    private var mockNetwork: MockNetworkMonitor!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchHeroesUseCase()
        mockNetwork = MockNetworkMonitor()
    }
    
    override func tearDown() {
        mockUseCase = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testInitialLoad_populatesHeroes_whenConnected() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Spider-Man", imageUrl: "", description: ""),
            Character(id: 2, name: "Iron Man", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results.first?.name, "Iron Man")
        XCTAssertEqual(results.last?.name, "Spider-Man")
    }
    
    func testInitialLoad_usesCachedHeroes_whenOffline() async {
        // Given
        mockUseCase.cachedHeroes = [
            Character(id: 3, name: "Hulk", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = false
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Hulk")
    }
    
    func testFilterHeroes_sortsAlphabetically() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "zeta", imageUrl: "", description: ""),
            Character(id: 2, name: "alpha", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.first?.name.lowercased(), "alpha")
        XCTAssertEqual(results.last?.name.lowercased(), "zeta")
    }
    
    func testFilterHeroes_filtersCorrectly() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Spider-Man", imageUrl: "", description: ""),
            Character(id: 2, name: "Thor", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        await MainActor.run {
            viewModel.searchText = "thor"
            viewModel.filterHeroes()
        }
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name.lowercased(), "thor")
    }
    
    func testInitialLoad_deduplicatesResults() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Spider-Man", imageUrl: "", description: ""),
            Character(id: 1, name: "Spider-Man", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 1)
    }
    
    func testInitialLoad_calledTwice_shouldNotDuplicate() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Hero", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        await viewModel.initialLoad()
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 1)
    }
    
    func testLoadFromEmptyCache_whenOffline_shouldShowEmptyList() async {
        // Given
        mockUseCase.cachedHeroes = []
        mockNetwork.isConnected = false
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 0)
    }
    
    func testLoadingStateUpdatesDuringFetch() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Hero", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.fetchHeroes()
        
        // Then
        let loading = await MainActor.run { viewModel.isLoading }
        XCTAssertFalse(loading)
    }
    
    func testLoadMoreIfNeeded_triggersFetchWhenLastItem() async {
        // Given
        mockUseCase.heroesToReturn = (1...40).map {
            Character(id: $0, name: "Hero \($0)", imageUrl: "", description: "")
        }
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        
        let lastID = await MainActor.run { viewModel.heroCellViewModels.last!.id }
        let last = await MainActor.run {
            viewModel.heroCellViewModels.first(where: { $0.id == lastID })!
        }
        await viewModel.loadMoreIfNeeded(currentItem: last)
        
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 40)
        XCTAssertEqual(results.first?.name, "Hero 1")
        XCTAssertTrue(results.contains { $0.name == "Hero 40" })
    }
    
    func testLoadMoreIfNeeded_appendsResults() async {
        // Given
        mockUseCase.heroesToReturn = (1...40).map {
            Character(id: $0, name: "Hero \($0)", imageUrl: "", description: "")
        }
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        let last = await MainActor.run { viewModel.heroCellViewModels.last! }
        await viewModel.loadMoreIfNeeded(currentItem: last)
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 40)
    }
    
    func testLoadMoreIfNeeded_doesNotTriggerWhenNotLastItem() async {
        // Given
        mockUseCase.heroesToReturn = (1...40).map {
            Character(id: $0, name: "Hero \($0)", imageUrl: "", description: "")
        }
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        let nonLast = await MainActor.run { viewModel.heroCellViewModels.first! }
        await viewModel.loadMoreIfNeeded(currentItem: nonLast)
        
        // Then
        await Task.yield()
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 20, "Should not load more unless last item")
    }
    
    func testPersistCurrentListIfNeeded_savesHeroes() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Persisted", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        await viewModel.persistCurrentListIfNeeded()
        
        // Then
        let saved = mockUseCase.cachedHeroes
        XCTAssertEqual(saved.count, 1)
        XCTAssertEqual(saved.first?.name, "Persisted")
    }
    
    func testHandleNetworkChange_recoversFromOffline() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 99, name: "ReconnectHero", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // Simulate offline
        await MainActor.run {
            mockNetwork.isConnected = false
        }
        
        // Simulate reconnect
        await MainActor.run {
            mockNetwork.isConnected = true
        }
        
        // Then
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertTrue(results.contains { $0.name == "ReconnectHero" })
    }
    
    func testFilterHeroes_returnsAllWhenSearchEmpty() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "A", imageUrl: "", description: ""),
            Character(id: 2, name: "B", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await viewModel.initialLoad()
        await MainActor.run {
            viewModel.searchText = ""
            viewModel.filterHeroes()
        }
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 2)
    }
    
    func testSearchDebounce_doesNotCrashOnRapidTyping() async {
        // Given
        mockUseCase.heroesToReturn = (1...5).map {
            Character(id: $0, name: "Hero \($0)", imageUrl: "", description: "")
        }
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        await viewModel.initialLoad()
        
        // When
        await MainActor.run {
            viewModel.searchText = "h"
            viewModel.searchText = "he"
            viewModel.searchText = "her"
            viewModel.searchText = "hero"
        }
        
        // Then
        await Task.yield()
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertGreaterThan(results.count, 0)
    }
    
    // MARK: - Helpers
    
    private func makeViewModel() async -> HeroesListViewModel {
        await MainActor.run {
            HeroesListViewModel(
                fetchHeroesUseCase: mockUseCase,
                networkMonitor: mockNetwork
            )
        }
    }
}
