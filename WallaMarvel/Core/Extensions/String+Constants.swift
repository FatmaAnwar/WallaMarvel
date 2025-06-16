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
    
    // MARK: - Accessibility Labels
    static let accHeroListLabel = "Marvel Heroes List"
    static let accHeroCellHint = "Tap to view details"
    static let accLoadingHint = "Loading data from the server"
    
    static func accHeroImage(name: String) -> String {
        "Image of \(name)"
    }
    
    static func accHeroCell(name: String) -> String {
        "Hero: \(name)"
    }
    
    static func accHeroDetailLabel(name: String) -> String {
        "Hero name: \(name)"
    }
    
    static func accHeroDescription(text: String) -> String {
        "Hero description: \(text)"
    }
    
    static func accHeroImageUnavailable(name: String) -> String {
        "No image available for \(name)"
    }
    
    // MARK: - Errors
    static let imageLoadFailed = "Failed to load image"
    static let heroFetchError = "Error fetching heroes"
    
    // MARK: - Accessibility Identifiers
    static let identifierHeroListTitle = "heroListTitle"
    static let identifierSearchField = "searchTextField"
    static let identifierHeroListSection = "heroListSection"
    static let identifierLoadingIndicator = "loadingIndicator"
    static let identifierOfflineBanner = "offlineBanner"
    static let identifierOnlineToast = "onlineToast"
    static let identifierHeroDetailName = "heroDetailName"
    static let identifierHeroDetailDescription = "heroDetailDescription"
    static let identifierFallbackImage = "fallbackImage"
}
