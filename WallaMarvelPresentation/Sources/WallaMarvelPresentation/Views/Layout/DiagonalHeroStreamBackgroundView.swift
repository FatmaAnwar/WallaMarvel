//
//  DiagonalHeroStreamBackgroundView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 16/06/2025.
//

import SwiftUI
import Kingfisher

@available(iOS 15.0, *)
struct DiagonalHeroStreamBackgroundView<VM: HeroCellViewModelProtocol>: View {
    let heroes: [VM]
    
    private let rows = 6
    private let cardSize: CGFloat = 100
    private let spacing: CGFloat = 24
    private let speed: CGFloat = 20
    private let rotationAngle: Angle = .degrees(-12)
    
    private var cachedHeroRows: [[VM]] {
        var result: [[VM]] = []
        for _ in 0..<rows {
            let row = Array(heroes.shuffled().prefix(15))
            result.append(row)
        }
        return result
    }
    
    var body: some View {
        let heroRows = cachedHeroRows
        
        return GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                VStack(spacing: spacing) {
                    ForEach(0..<rows, id: \.self) { row in
                        let rowHeroes = heroRows[row]
                        let repeated = rowHeroes + rowHeroes + rowHeroes
                        let rowWidth = CGFloat(repeated.count) * (cardSize + spacing)
                        let xOffset = CGFloat(time * speed).truncatingRemainder(dividingBy: rowWidth)
                        
                        HStack(spacing: spacing) {
                            ForEach(Array(repeated.enumerated()), id: \.offset) { _, hero in
                                KFImage(hero.imageURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: cardSize, height: cardSize)
                                    .clipShape(RoundedRectangle(cornerRadius: 22))
                                    .opacity(0.3)
                                    .allowsHitTesting(false)
                            }
                        }
                        .offset(x: -xOffset + CGFloat(row) * 40)
                        .opacity(0.6 - Double(row) * 0.07)
                    }
                }
                
                .rotationEffect(rotationAngle)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, -350)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
