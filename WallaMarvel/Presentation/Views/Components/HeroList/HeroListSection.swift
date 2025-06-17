//
//  HeroListSection.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import SwiftUI

@available(iOS 15.0, *)
struct HeroListSection: View {
    @ObservedObject var viewModel: HeroesListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.heroCellViewModels) { hero in
                NavigationLink(
                    destination: HeroDetailScreen(viewModel: HeroDetailViewModel(character: hero.character))
                ) {
                    HeroCellView(viewModel: hero) {}
                }
                .onAppear {
                    viewModel.loadMoreIfNeeded(currentItem: hero)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}
