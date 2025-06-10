//
//  HeroDetailScreen.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct HeroDetailScreen: View {
    @StateObject var viewModel: HeroDetailVM

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let imageURL = viewModel.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                            .padding(.top, 24)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 250, height: 250)
                            .overlay(ProgressView())
                            .padding(.top, 24)
                    }
                }

                Text(viewModel.name)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.primary)

                Text(viewModel.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hero Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
