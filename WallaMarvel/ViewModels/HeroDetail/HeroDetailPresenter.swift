//
//  HeroDetailPresenter.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 08/06/2025.
//

import Foundation

protocol HeroDetailUI: AnyObject {
    func displayHero(name: String, description: String, imageURL: URL?)
}

protocol HeroDetailPresenterProtocol {
    func viewDidLoad()
}

final class HeroDetailPresenter: HeroDetailPresenterProtocol {
    weak var ui: HeroDetailUI?
    private let hero: CharacterDataModel
    
    init(hero: CharacterDataModel, ui: HeroDetailUI?) {
        self.hero = hero
        self.ui = ui
    }
    
    func viewDidLoad() {
        let url = URL(string: "\(hero.thumbnail.path).\(hero.thumbnail.extension)")
        ui?.displayHero(name: hero.name, description: hero.description ?? "", imageURL: url)
    }
}
