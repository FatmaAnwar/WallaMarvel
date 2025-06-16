//
//  TitleHeaderView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import SwiftUI

@available(iOS 14.0, *)
struct TitleHeaderView: View {
    let title: String
    
    var body: some View {
        Text(verbatim: title)
            .font(.system(size: 32, weight: .bold))
            .padding(.horizontal)
            .accessibilityIdentifier(String.identifierHeroListTitle)
    }
}
