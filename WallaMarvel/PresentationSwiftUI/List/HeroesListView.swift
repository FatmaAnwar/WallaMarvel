//
//  HeroesListView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import SwiftUI

@available(iOS 15.0, *)
struct HeroesListView: View {
    @StateObject private var viewModel = HeroesListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    if viewModel.showOfflineBanner {
                        OfflineBannerView()
                    }
                    
                    mainContent
                }
                
                if viewModel.showOnlineToast {
                    OnlineToastView()
                }
                
                if viewModel.isLoading && viewModel.heroCellViewModels.isEmpty {
                    ProgressView(String.loadingText)
                        .progressViewStyle(CircularProgressViewStyle())
                        .accessibilityLabel(String.loadingText)
                        .accessibilityHint(String.accLoadingHint)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityLabel(String.accHeroListLabel)
        }
        .onAppear {
            viewModel.initialLoad()
        }
    }
    
    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            TitleHeaderView(title: .heroListTitle)
            
            SearchBarView(text: $viewModel.searchText) {
                viewModel.filterHeroes()
            }
            
            HeroListSection(viewModel: viewModel)
        }
        .padding(.horizontal)
    }
}
