//
//  HeroCellView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI
import Kingfisher

@available(iOS 15.0, *)
struct HeroCellView: View {
    let viewModel: HeroCellViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(viewModel.imageURL)
                .placeholder {
                    Color.gray.opacity(0.2)
                }
                .cacheMemoryOnly(false)
                .cacheOriginalImage()
                .onFailure { error in
                    print("Failed to load image for \(viewModel.name): \(error.localizedDescription)")
                }
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            Text(viewModel.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
