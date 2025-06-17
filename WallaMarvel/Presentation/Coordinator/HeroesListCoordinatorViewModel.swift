//
//  HeroesListCoordinatorViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 17/06/2025.
//

import Foundation
import SwiftUI
import WallaMarvelDomain

@available(iOS 16.0, *)
@MainActor
final class HeroesListCoordinatorViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func onHeroSelected(_ hero: Character) {
        navigationPath.append(hero)
    }
    
    func resetNavigation() {
        navigationPath.removeLast(navigationPath.count)
    }
}
