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
    
    func test_initialLoad_populatesHeroes_whenConnected() async {
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
    }
    
    func test_initialLoad_usesCachedHeroes_whenOffline() async {
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
    
    func test_initialLoad_deduplicatesResults() async {
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
    
    func test_initialLoad_calledTwice_shouldNotDuplicate() async {
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
    
    func test_loadFromEmptyCache_whenOffline_shouldShowEmptyList() async {
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
    
    func test_filterHeroes_sortsAlphabetically() async {
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
    
    func test_filterHeroes_filtersCorrectly() async {
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
    
    func test_filterHeroes_returnsAllWhenSearchEmpty() async {
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
    
    func test_searchDebounce_doesNotCrashOnRapidTyping() async {
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
    
    func test_showOfflineBanner_whenNetworkGoesOffline() async {
        // Given
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        await MainActor.run {
            mockNetwork.isConnected = false
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        let bannerShown = await MainActor.run { viewModel.showOfflineBanner }
        XCTAssertTrue(bannerShown)
    }
    
    func test_showOnlineToast_whenNetworkComesOnline() async {
        // Given
        mockNetwork.isConnected = false
        let viewModel = await makeViewModel()
        
        // When
        await MainActor.run {
            mockNetwork.isConnected = true
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        let toastShown = await MainActor.run { viewModel.showOnlineToast }
        XCTAssertTrue(toastShown)
    }
    
    func test_isLoadingFlag_isTrueDuringFetch_andFalseBeforeAndAfter() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 1, name: "Test Hero", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // When
        let isLoadingBeforeFetch = await MainActor.run { viewModel.isLoading }
        
        let task = Task {
            await viewModel.fetchHeroes()
        }
        
        var isLoadingDuring: Bool = false
        for _ in 0..<10 {
            try? await Task.sleep(nanoseconds: 50_000_000)
            isLoadingDuring = await MainActor.run { viewModel.isLoading }
            if isLoadingDuring { break }
        }
        
        await task.value
        let isLoadingAfter = await MainActor.run { viewModel.isLoading }
        
        // Then
        XCTAssertFalse(isLoadingBeforeFetch)
        XCTAssertTrue(isLoadingDuring, "Expected isLoading to be true during fetch.")
        XCTAssertFalse(isLoadingAfter)
    }
    
    func test_loadMoreIfNeeded_triggersFetchWhenLastItem() async {
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
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 40)
    }
    
    func test_loadMoreIfNeeded_doesNotTriggerWhenNotLastItem() async {
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
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertEqual(results.count, 20, "Should not load more unless last item")
    }
    
    func test_persistCurrentListIfNeeded_savesHeroes() async {
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
    
    func test_handleNetworkChange_recoversFromOffline() async {
        // Given
        mockUseCase.heroesToReturn = [
            Character(id: 99, name: "ReconnectHero", imageUrl: "", description: "")
        ]
        mockNetwork.isConnected = true
        let viewModel = await makeViewModel()
        
        // Simulate offline then reconnect
        await MainActor.run {
            mockNetwork.isConnected = false
        }
        await MainActor.run {
            mockNetwork.isConnected = true
        }
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Then
        let results = await MainActor.run { viewModel.heroCellViewModels }
        XCTAssertTrue(results.contains { $0.name == "ReconnectHero" })
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

