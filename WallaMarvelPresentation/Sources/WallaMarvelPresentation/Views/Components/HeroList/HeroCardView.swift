//
//  HeroCardView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import SwiftUI
import Kingfisher

@preconcurrency
@available(iOS 15.0, *)
struct HeroCardView<VM: HeroCellViewModelProtocol>: View, Equatable {
    let viewModel: VM
    nonisolated let id: Int
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        self.id = viewModel.id
    }
    
    nonisolated static func == (lhs: HeroCardView<VM>, rhs: HeroCardView<VM>) -> Bool {
        lhs.id == rhs.id
    }
    
    var body: some View {
        VStack(spacing: 12) {
            KFImage(viewModel.imageURL)
                .placeholder {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.gray.opacity(0.2))
                }
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 6)
            
            Text(viewModel.name)
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .lineLimit(2)
                .frame(maxWidth: 140)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .frame(width: 160, height: 210)
        .accessibilityIdentifier("heroCard_\(id)")
    }
}
