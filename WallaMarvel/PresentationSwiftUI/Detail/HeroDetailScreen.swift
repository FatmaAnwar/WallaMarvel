//
//  HeroDetailScreen.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import SwiftUI
import Kingfisher

@available(iOS 15.0, *)
struct HeroDetailScreen<ViewModel: SwiftUIHeroDetailViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                heroImage
                heroName
                heroDescription
                Spacer()
            }
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(String.heroDetailTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var heroImage: some View {
        Group {
            if let url = viewModel.imageURL {
                KFImage(url)
                    .placeholder {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 250, height: 250)
                            .overlay(ProgressView())
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                    .padding(.top, 24)
                    .accessibilityLabel(String.accHeroImage(name: viewModel.name))
                    .accessibilitySortPriority(1)
            } else {
                Image(systemName: "person.crop.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
                    .padding(.top, 24)
                    .accessibilityLabel(String.accHeroImageUnavailable(name: viewModel.name))
                    .accessibilitySortPriority(1)
                    .accessibilityIdentifier(String.identifierFallbackImage)
            }
        }
    }
    
    private var heroName: some View {
        Text(viewModel.name)
            .font(.system(size: 28, weight: .bold))
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .foregroundColor(.primary)
            .dynamicTypeSize(.xSmall ... .accessibility5)
            .accessibilityLabel(String.accHeroDetailLabel(name: viewModel.name))
            .accessibilityIdentifier(String.identifierHeroDetailName)
    }
    
    private var heroDescription: some View {
        Text(viewModel.description)
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .dynamicTypeSize(.xSmall ... .accessibility5)
            .accessibilityLabel(String.accHeroDescription(text: viewModel.description))
            .textSelection(.enabled)
            .accessibilityIdentifier(String.identifierHeroDetailDescription)
    }
}
