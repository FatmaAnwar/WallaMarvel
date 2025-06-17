//
//  HeroesListView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import SwiftUI

@available(iOS 15.0, *)
struct HeroesListView: View {
    @StateObject var viewModel: HeroesListViewModel
    let onHeroSelected: (Character) -> Void
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            if viewModel.searchText.isEmpty {
                DiagonalHeroStreamBackgroundView(heroes: viewModel.heroCellViewModels)
            }
            
            MainContent(viewModel: viewModel, onHeroTap: onHeroSelected)
            
            if viewModel.isLoading && viewModel.heroCellViewModels.isEmpty {
                LoadingOverlay()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityLabel(String.accHeroListLabel)
        .onAppear {
            Task { await viewModel.initialLoad() }
        }
    }
}
