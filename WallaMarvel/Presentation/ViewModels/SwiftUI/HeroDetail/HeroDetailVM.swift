//
//  HeroDetailVM.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI

@MainActor
final class HeroDetailVM: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var imageURL: URL?
    
    private let hero: Character
    
    init(hero: Character) {
        self.hero = hero
        configure()
    }
    
    private func configure() {
        self.name = hero.name
        self.description = hero.description.isEmpty ? "No description available." : hero.description
        self.imageURL = URL(string: hero.imageUrl)
    }
}
