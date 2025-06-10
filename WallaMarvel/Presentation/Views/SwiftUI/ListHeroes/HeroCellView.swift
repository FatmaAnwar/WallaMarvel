//
//  HeroCellView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct HeroCellView: View {
    let viewModel: HeroCellViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: viewModel.imageURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            Text(viewModel.name)
                .font(.headline)
                .padding(.leading, 8)
        }
        .padding(.vertical, 6)
    }
}
