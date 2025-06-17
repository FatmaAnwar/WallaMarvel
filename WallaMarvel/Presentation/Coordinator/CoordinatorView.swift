//
//  CoordinatorView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 17/06/2025.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
struct CoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            coordinator.start(navigationPath: $navigationPath)
        }
        .navigationDestination(for: Character.self) { character in
            HeroDetailScreen(viewModel: HeroDetailViewModel(character: character))
        }
    }
}
