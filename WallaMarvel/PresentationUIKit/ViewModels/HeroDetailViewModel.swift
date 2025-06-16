//
//  HeroDetailViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 08/06/2025.
//

import Foundation

protocol HeroDetailViewModelDelegate: AnyObject {
    func displayHero(name: String, description: String, imageURL: URL?)
}

protocol HeroDetailViewModelProtocol {
    func viewDidLoad()
}

final class HeroDetailViewModel: HeroDetailViewModelProtocol {
    weak var delegate: HeroDetailViewModelDelegate?
    private let hero: Character
    
    init(hero: Character, delegate: HeroDetailViewModelDelegate?) {
        self.hero = hero
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        let url = URL(string: hero.imageUrl)
        let isValid = url?.scheme == "https" || url?.scheme == "http"
        let isUsable = url?.host != nil

        delegate?.displayHero(
            name: hero.name,
            description: hero.description,
            imageURL: isValid && isUsable ? url : nil
        )
    }
}
