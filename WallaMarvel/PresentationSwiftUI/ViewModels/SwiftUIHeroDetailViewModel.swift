//
//  SwiftUIHeroDetailViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI

@MainActor
final class SwiftUIHeroDetailViewModel: SwiftUIHeroDetailViewModelProtocol {
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
        
        imageURL = URL(string: character.imageUrl)
    }
}
