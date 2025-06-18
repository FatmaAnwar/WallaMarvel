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
    
    @State private var isEditing = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(String.searchHeroesPlaceholder, text: $text)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .shadow(radius: 1)
                .onChange(of: text) { _ in onChange() }
                .onTapGesture { isEditing = true }
                .accessibilityIdentifier(String.identifierSearchField)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onChange()
                    isEditing = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 12)
                }
                .transition(.opacity)
            }
        }
        .padding(.horizontal)
    }
}
