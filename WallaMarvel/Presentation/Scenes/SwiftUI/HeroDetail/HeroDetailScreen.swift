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
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 8)
                    .padding(.top)
                }
                
                Text(viewModel.name)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(viewModel.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom)
        }
        .navigationTitle("Hero Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
