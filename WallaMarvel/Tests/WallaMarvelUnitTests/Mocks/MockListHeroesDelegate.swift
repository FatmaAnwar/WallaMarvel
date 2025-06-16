//
//  MockListHeroesDelegate.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import Foundation
@testable import WallaMarvel

final class MockListHeroesDelegate: ListHeroesViewModelDelegate {
    var heroes: [HeroCellViewModel] = []
    var loadingStates: [Bool] = []
    
    func update(heroes: [HeroCellViewModel]) {
        self.heroes = heroes
    }
    
    func showLoading(_ show: Bool) {
        loadingStates.append(show)
    }
}
