//
//  String+Constants.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import Foundation

extension String {
    
    // MARK: - Screen Titles
    static let heroListTitle = "List of Heroes"
    static let heroDetailTitle = "Hero Detail"
    
    // MARK: - UI Placeholders
    static let searchHeroesPlaceholder = "Search heroes"
    static let offlineBannerText = "You're offline"
    static let onlineToastText = "Back online. Refreshing..."
    static let loadingText = "Loading..."
    static let unknownName = "Unknown"
    static let noDescription = "No description available."
    
    // MARK: - Accessibility
    static let accHeroListLabel = "Marvel Heroes List"
    static func accHeroImage(name: String) -> String { "Image of \(name)" }
    static func accHeroCell(name: String) -> String { "Hero: \(name)" }
    static func accHeroDetailLabel(name: String) -> String { "Hero name: \(name)" }
    static func accHeroDescription(text: String) -> String { "Hero description: \(text)" }
    static let accHeroCellHint = "Tap to view details"
    static let accLoadingHint = "Loading data from the server"
    
    // MARK: - Errors
    static let imageLoadFailed = "Failed to load image"
    static let heroFetchError = "Error fetching heroes"
}

