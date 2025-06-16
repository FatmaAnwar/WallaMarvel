//
//  HeroDetailViewModelTests.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
import XCTest
@testable import WallaMarvel

final class HeroDetailViewModelTests: XCTestCase {

    private final class MockDelegate: HeroDetailViewModelDelegate {
        var capturedName: String?
        var capturedDescription: String?
        var capturedImageURL: URL?

        func displayHero(name: String, description: String, imageURL: URL?) {
            capturedName = name
            capturedDescription = description
            capturedImageURL = imageURL
        }
    }

    func test_viewDidLoad_callsDelegateWithCorrectData() {
        // Given
        let character = Character(
            id: 1,
            name: "Thor",
            imageUrl: "https://example.com/thor.jpg",
            description: "God of Thunder"
        )
        let delegate = MockDelegate()
        let viewModel = HeroDetailViewModel(hero: character, delegate: delegate)

        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertEqual(delegate.capturedName, "Thor")
        XCTAssertEqual(delegate.capturedDescription, "God of Thunder")
        XCTAssertEqual(delegate.capturedImageURL?.absoluteString, "https://example.com/thor.jpg")
    }

    func test_viewDidLoad_withInvalidImageURL_setsNil() {
        // Given
        let character = Character(
            id: 2,
            name: "Invalid Hero",
            imageUrl: "ht!tp:/badURL",
            description: "Has invalid image URL"
        )
        let delegate = MockDelegate()
        let viewModel = HeroDetailViewModel(hero: character, delegate: delegate)

        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertNil(delegate.capturedImageURL)
    }

    func test_viewDidLoad_withEmptyDescription_passesItAsIs() {
        // Given
        let character = Character(
            id: 3,
            name: "Mystery Hero",
            imageUrl: "https://example.com/hero.png",
            description: ""
        )
        let delegate = MockDelegate()
        let viewModel = HeroDetailViewModel(hero: character, delegate: delegate)

        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertEqual(delegate.capturedDescription, "")
    }
}
