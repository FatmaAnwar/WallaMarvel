//
//  SearchBarView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import SwiftUI

@available(iOS 14.0, *)
struct SearchBarView: View {
    @Binding var text: String
    var onChange: () -> Void
    
    var body: some View {
        TextField(String.searchHeroesPlaceholder, text: $text)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(radius: 1)
            .onChange(of: text) { _ in onChange() }
    }
}
