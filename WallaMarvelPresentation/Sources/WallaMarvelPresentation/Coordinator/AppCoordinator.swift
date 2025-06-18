//
//  AppCoordinator.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 17/06/2025.
//

import Foundation
import SwiftUI
import WallaMarvelCore
import WallaMarvelData

@available(iOS 16.0, *)
@MainActor
public final class AppCoordinator: ObservableObject {
    public init() {}
    
    public func start() -> some View {
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
        
        return HeroesListEntryView(viewModel: viewModel)
    }
}
