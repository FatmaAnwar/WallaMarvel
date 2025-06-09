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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let listVC = ListHeroesViewController()
        let viewModel = ListHeroesViewModel()
        viewModel.delegate = listVC
        listVC.viewModel = viewModel
        
        listVC.onHeroSelected = { [weak self] hero in
            self?.navigateToDetail(hero: hero)
        }

        navigationController.pushViewController(listVC, animated: false)
    }
    
    private func navigateToDetail(hero: CharacterDataModel) {
        let detailVC = HeroDetailViewController()
        let viewModel = HeroDetailViewModel(hero: hero, delegate: detailVC)
        detailVC.viewModel = viewModel

        navigationController.pushViewController(detailVC, animated: true)
    }
}
