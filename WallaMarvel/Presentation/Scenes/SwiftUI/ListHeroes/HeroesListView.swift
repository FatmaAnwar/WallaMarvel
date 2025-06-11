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
    @State private var showOnlineToast = false
    @State private var showOfflineBanner = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    if showOfflineBanner {
                        Text("You're offline")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.95))
                            .foregroundColor(.white)
                            .font(.caption)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: showOfflineBanner)
                    }
                    
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
                        
                        List {
                            ForEach(viewModel.heroCellViewModels) { hero in
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
                }
                
                if showOnlineToast {
                    VStack {
                        Spacer()
                        Text("Back online. Refreshing...")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.95))
                            .foregroundColor(.white)
                            .font(.caption)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: showOnlineToast)
                    }
                    .zIndex(1)
                }
                
                if viewModel.isLoading && viewModel.heroCellViewModels.isEmpty {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
        .task {
            viewModel.preloadCachedHeroesIfAvailable()
            if network.isConnected {
                await viewModel.getHeroes()
            }
            animateList = true
        }
        .onReceive(network.$isConnected) { isConnected in
            if isConnected {
                showOfflineBanner = false
                showOnlineToast = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showOnlineToast = false
                }
                
                Task {
                    viewModel.isLoading = true
                    viewModel.preloadCachedHeroesIfAvailable()
                    await viewModel.getHeroes(resetBeforeFetch: true)
                    viewModel.isLoading = false
                }
            } else {
                showOfflineBanner = true
                viewModel.persistCurrentListIfNeeded()
            }
        }
    }
}
