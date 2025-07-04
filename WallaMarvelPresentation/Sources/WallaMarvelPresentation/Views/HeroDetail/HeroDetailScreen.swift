//
//  HeroDetailScreen.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import SwiftUI
import Kingfisher

@available(iOS 15.0, *)
struct HeroDetailScreen<ViewModel: HeroDetailViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        ZStack {
            BackgroundGradient()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    AnimatedFloatingImageView(url: viewModel.imageURL, reduceMotion: reduceMotion)
                    
                    Text(viewModel.name)
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .accessibilityIdentifier(String.identifierHeroDetailName)
                    
                    Text(viewModel.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .accessibilityIdentifier(String.identifierHeroDetailDescription)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(viewModel.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
