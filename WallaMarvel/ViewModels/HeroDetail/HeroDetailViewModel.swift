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
    private let hero: CharacterDataModel
    
    init(hero: CharacterDataModel, delegate: HeroDetailViewModelDelegate?) {
        self.hero = hero
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        let url = URL(string: "\(hero.thumbnail.path).\(hero.thumbnail.extension)")
        delegate?.displayHero(name: hero.name, description: hero.description ?? "", imageURL: url)
    }
}
