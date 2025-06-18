//
//  AnimatedFloatingImageView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import SwiftUI
import Kingfisher

@available(iOS 15.0, *)
struct AnimatedFloatingImageView: View {
    let url: URL?
    let reduceMotion: Bool
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let amplitude: CGFloat = 8
            let speed: Double = 1.5
            let yOffset = reduceMotion ? 0 : CGFloat(sin(time * speed)) * amplitude
            
            KFImage(url)
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.systemGroupedBackground))
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                .offset(y: yOffset)
                .animation(.easeInOut(duration: 1), value: yOffset)
        }
        .frame(height: 270)
        .padding(.top, 24)
    }
}
