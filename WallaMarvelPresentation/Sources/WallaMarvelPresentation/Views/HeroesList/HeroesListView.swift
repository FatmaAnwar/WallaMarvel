//
//  HeroesListView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import SwiftUI
import WallaMarvelDomain
import WallaMarvelCore

@available(iOS 16.0, *)
struct HeroesListView: View {
    @StateObject var viewModel: HeroesListViewModel
    @ObservedObject var coordinator: HeroesListCoordinatorViewModel
    
    @State private var showStream = false
    @State private var streamHeroes: [HeroCellViewModel] = []
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack {
                BackgroundGradient()
                
                if showStream && !streamHeroes.isEmpty && viewModel.searchText.isEmpty {
                    DiagonalHeroStreamBackgroundView(heroes: streamHeroes)
                        .transition(.opacity)
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
                Task {
                    await viewModel.initialLoad()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        showStream = true
                    }
                }
            }
            .onChange(of: viewModel.heroCellViewModels) { newList in
                if streamHeroes.isEmpty && !newList.isEmpty && viewModel.searchText.isEmpty {
                    streamHeroes = Array(newList.shuffled().prefix(100))
                }
            }
        }
    }
}
