//
//  MainContent.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import SwiftUI

@available(iOS 15.0, *)
struct MainContent: View {
    @ObservedObject var viewModel: HeroesListViewModel
    let onHeroTap: (Character) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                TitleHeaderView(title: .heroListTitle)
                
                SearchBarView(text: $viewModel.searchText) {
                    viewModel.filterHeroes()
                }
                .padding(.top, 8)
                
                HeroGridSection(viewModel: viewModel, onHeroTap: onHeroTap)
                    .accessibilityIdentifier(String.identifierHeroListSection)
                    .padding(.top, 8)
            }
            .padding(.horizontal)
        }
    }
}
