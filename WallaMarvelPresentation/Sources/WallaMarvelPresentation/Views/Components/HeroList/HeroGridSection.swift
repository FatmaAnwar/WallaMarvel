//
//  HeroGridSection.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import SwiftUI
import Kingfisher
import WallaMarvelDomain

@available(iOS 15.0, *)
struct HeroGridSection: View {
    @ObservedObject var viewModel: HeroesListViewModel
    let onHeroTap: (Character) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.heroCellViewModels) { hero in
                    HeroCardView(viewModel: hero)
                        .onTapGesture {
                            onHeroTap(hero.character)
                        }
                        .transition(.scale)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: hero)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .overlay(
            Group {
                if viewModel.isLoading && !viewModel.heroCellViewModels.isEmpty {
                    ZStack {
                        Color.black.opacity(0.05)
                            .ignoresSafeArea()
                        LoadingOverlay()
                    }
                    .transition(.opacity)
                }
            }
        )
    }
}
