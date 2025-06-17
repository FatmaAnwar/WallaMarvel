//
//  HeroesListView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import SwiftUI

@available(iOS 16.0, *)
struct HeroesListView: View {
    @StateObject var viewModel: HeroesListViewModel
    @ObservedObject var coordinator: HeroesListCoordinatorViewModel
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack {
                BackgroundGradient()
                
                if viewModel.searchText.isEmpty {
                    DiagonalHeroStreamBackgroundView(heroes: viewModel.heroCellViewModels)
                }
                
                MainContent(viewModel: viewModel) { selectedHero in
                    coordinator.onHeroSelected(selectedHero)
                }
                
                if viewModel.isLoading && viewModel.heroCellViewModels.isEmpty {
                    LoadingOverlay()
                }
            }
            .navigationDestination(for: Character.self) { hero in
                HeroDetailScreen(viewModel: HeroDetailViewModel(character: hero))
            }
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityLabel(String.accHeroListLabel)
            .onAppear {
                Task { await viewModel.initialLoad() }
            }
        }
    }
}
