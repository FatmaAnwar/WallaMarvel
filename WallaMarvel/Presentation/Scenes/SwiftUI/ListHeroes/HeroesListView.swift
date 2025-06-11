//
//  HeroesListView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct HeroesListView: View {
    @StateObject private var viewModel = HeroesListViewModel()
    @ObservedObject private var network = NetworkMonitor.shared
    @State private var animateList = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("List of Heroes")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.horizontal)
                    
                    TextField("Search heroes", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(radius: 1)
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.filterHeroes()
                        }
                    
                    if !network.isConnected {
                        Text("You're offline")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.95))
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    
                    List {
                        ForEach(viewModel.heroCellViewModels, id: \.name) { hero in
                            NavigationLink(
                                destination: HeroDetailScreen(viewModel: HeroDetailVM(hero: hero.originalHero))
                            ) {
                                HeroCellView(viewModel: hero)
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
                
                if viewModel.isLoading && viewModel.heroCellViewModels.isEmpty {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
        .task {
            viewModel.preloadCachedHeroesIfAvailable()
            await viewModel.getHeroes()
            animateList = true
        }
        .onChange(of: network.isConnected) { isConnected in
            if isConnected {
                viewModel.heroCellViewModels = []
                Task {
                    viewModel.isLoading = true
                    await viewModel.getHeroes()
                    viewModel.isLoading = false
                }
            }
        }
    }
}
