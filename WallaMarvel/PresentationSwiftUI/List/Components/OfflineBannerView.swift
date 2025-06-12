//
//  OfflineBannerView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import SwiftUI

struct OfflineBannerView: View {
    var body: some View {
        Text(verbatim: .offlineBannerText)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.95))
            .foregroundColor(.white)
            .font(.caption)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut, value: true)
    }
}
