//
//  HeroCellView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import SwiftUI
import Kingfisher

@available(iOS 15.0, *)
struct HeroCellView<VM: HeroCellViewModelProtocol>: View {
    let viewModel: VM
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(viewModel.imageURL)
                .placeholder { Color.gray.opacity(0.2) }
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .accessibilityHidden(true)
            
            Text(viewModel.name)
                .font(.headline)
                .foregroundColor(.primary)
                .dynamicTypeSize(.xSmall ... .xxLarge)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String.accHeroCell(name: viewModel.name))
        .accessibilityHint(String.accHeroCellHint)
        .accessibilityAddTraits(.isButton)
        .accessibilitySortPriority(1)
        .accessibilityIdentifier("heroCell_\(viewModel.id)")
    }
}
