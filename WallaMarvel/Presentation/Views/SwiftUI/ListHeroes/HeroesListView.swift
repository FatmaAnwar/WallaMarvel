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
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        TextField("Search heroes", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 8)
                    }
                    
                    ForEach(viewModel.heroCellViewModels, id: \.name) { hero in
                        NavigationLink(destination: Text("Hero Detail for \(hero.name)")) {
                            HeroCellView(viewModel: hero)
                        }
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: hero)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("List of Heroes")
                
                if viewModel.isLoading && viewModel.heroCellViewModels.isEmpty {
                    ProgressView("Loading...")
                }
            }
        }
        .task {
            await viewModel.getHeroes()
        }
    }
}
