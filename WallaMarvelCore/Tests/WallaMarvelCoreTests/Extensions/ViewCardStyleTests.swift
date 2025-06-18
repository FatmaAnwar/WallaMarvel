//
//  ViewCardStyleTests.swift
//  WallaMarvelCore
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation
import XCTest
import SwiftUI
@testable import WallaMarvelCore

final class ViewCardStyleTests: XCTestCase {
    
    struct DummyView: View {
        var body: some View {
            Text("Card")
                .cardStyle()
        }
    }

    func test_cardStyle_appliesModifier() {
        let expectation = XCTestExpectation(description: "Render view")

        Task { @MainActor in
            let view = DummyView()
            _ = view.body
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
