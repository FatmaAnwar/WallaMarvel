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
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                KFImage(viewModel.imageURL)
                    .placeholder { Color.gray.opacity(0.2) }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
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
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(viewModel.name)
        .accessibilityIdentifier("heroCell_\(viewModel.id)")
    }
}
