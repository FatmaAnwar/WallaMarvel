//
//  HeroesCoordinator.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import UIKit

final class HeroesCoordinator {
    private let navigationController: UINavigationController
    private let fetchHeroesUseCase: FetchHeroesUseCaseProtocol

    init(
        navigationController: UINavigationController,
        fetchHeroesUseCase: FetchHeroesUseCaseProtocol = FetchHeroesUseCase()
    ) {
        self.navigationController = navigationController
        self.fetchHeroesUseCase = fetchHeroesUseCase
    }

    func start() {
        let listVC = ListHeroesViewController()
        let viewModel = ListHeroesViewModel(getHeroesUseCase: fetchHeroesUseCase)

        viewModel.delegate = listVC
        listVC.viewModel = viewModel

        listVC.onHeroSelected = { [weak self] heroCellViewModel in
            self?.navigateToDetail(hero: heroCellViewModel.originalHero)
        }

        navigationController.pushViewController(listVC, animated: false)
    }

    private func navigateToDetail(hero: Character) {
        let detailVC = HeroDetailViewController()
        let viewModel = HeroDetailViewModel(hero: hero, delegate: detailVC)
        detailVC.viewModel = viewModel

        navigationController.pushViewController(detailVC, animated: true)
    }
}
