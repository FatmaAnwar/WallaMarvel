//
//  HeroDetailViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI
import WallaMarvelDomain

@MainActor
final class HeroDetailViewModel: HeroDetailViewModelProtocol {
    @Published private(set) var name: String = ""
    @Published private(set) var description: String = ""
    @Published private(set) var imageURL: URL?
    
    private let character: Character
    
    init(character: Character) {
        self.character = character
        loadHeroDetails()
    }
    
    private func loadHeroDetails() {
        name = character.name
        
        let trimmedDescription = character.description.trimmingCharacters(in: .whitespacesAndNewlines)
        description = trimmedDescription.isEmpty ? String.noDescription : trimmedDescription
        
        if let url = URL(string: character.imageUrl),
           let scheme = url.scheme, (scheme == "http" || scheme == "https"),
           url.host != nil {
            imageURL = url
        } else {
            imageURL = nil
        }
    }
}
