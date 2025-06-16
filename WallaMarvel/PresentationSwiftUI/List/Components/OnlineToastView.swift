//
//  OnlineToastView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 12/06/2025.
//

import SwiftUI

@available(iOS 14.0, *)
struct OnlineToastView: View {
    var body: some View {
        VStack {
            Spacer()
            Text(verbatim: .onlineToastText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.95))
                .foregroundColor(.white)
                .font(.caption)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: true)
                .accessibilityIdentifier(String.identifierOnlineToast)
            
        }
        .zIndex(1)
    }
}
