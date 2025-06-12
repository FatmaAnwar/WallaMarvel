//
//  HeroesCoordinator.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation
import UIKit

final class HeroesCoordinator {
    private let navigationController: UINavigationController
    private let heroesService: HeroesServiceProtocol
    
    init(
        navigationController: UINavigationController,
        heroesService: HeroesServiceProtocol = HeroesService()
    ) {
        self.navigationController = navigationController
        self.heroesService = heroesService
    }
    
    func start() {
        let listVC = ListHeroesViewController()
        let viewModel = ListHeroesViewModel(heroesService: heroesService)
        
        viewModel.delegate = listVC
        listVC.viewModel = viewModel
        
        listVC.onHeroSelected = { [weak self] heroCellViewModel in
            let hero = heroCellViewModel.originalHero
            self?.navigateToDetail(hero: hero)
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
