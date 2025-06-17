//
//  HeroesListEntryView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 17/06/2025.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
struct HeroesListEntryView: View {
    @StateObject private var viewModel: HeroesListViewModel
    @StateObject private var coordinator = HeroesListCoordinatorViewModel()
    
    init(viewModel: HeroesListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HeroesListView(
            viewModel: viewModel,
            coordinator: coordinator
        )
    }
}
