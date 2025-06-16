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
        GeometryReader { geo in
            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let amplitude: CGFloat = 8
                let speed: Double = 1.5
                
                let yOffset = reduceMotion ? 0 : CGFloat(sin(time * speed)) * amplitude
                
                HStack {
                    KFImage(url)
                        .placeholder {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 250, height: 250)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                        .offset(y: yOffset)
                        .animation(.easeInOut(duration: 1), value: yOffset)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 270)
        .padding(.top, 24)
    }
}
