//
//  HeroDetailViewModelProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation

@MainActor
protocol HeroDetailViewModelProtocol: ObservableObject {
    var name: String { get }
    var description: String { get }
    var imageURL: URL? { get }
}
