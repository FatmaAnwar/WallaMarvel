//
//  ListHeroesViewModelDelegate.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation

protocol ListHeroesViewModelDelegate: AnyObject {
    func update(heroes: [HeroCellViewModel])
    func showLoading(_ show: Bool)
}
