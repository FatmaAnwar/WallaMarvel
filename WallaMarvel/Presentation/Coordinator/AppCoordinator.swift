//
//  AppCoordinator.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 17/06/2025.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
@MainActor
final class AppCoordinator: ObservableObject {
    func start(navigationPath: Binding<NavigationPath>) -> some View {
        let apiService = MarvelAPIClient()
        let remoteDataSource = MarvelRemoteDataSource(apiClient: apiService)
        let repository = CharacterRepository(
            remoteDataSource: remoteDataSource,
            cacheRepository: CharacterCacheRepository(),
            characterMapper: CharacterMapper()
        )
        let useCase = FetchCharactersUseCase(repository: repository)
        let networkMonitor = NetworkMonitor.shared
        let viewModel = HeroesListViewModel(
            fetchHeroesUseCase: useCase,
            networkMonitor: networkMonitor
        )
        
        return HeroesListView(viewModel: viewModel) { selectedHero in
            navigationPath.wrappedValue.append(selectedHero)
        }
    }
}
