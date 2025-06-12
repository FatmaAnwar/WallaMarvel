//
//  HeroDetailView.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation
import UIKit
import Kingfisher

final class HeroDetailView: UIView {
    let heroImageView = UIImageView()
    let heroNameLabel = UILabel()
    let heroDescriptionLabel = UILabel()
    let imageLoadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        [heroImageView, heroNameLabel, heroDescriptionLabel, imageLoadingIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        heroNameLabel.font = .boldSystemFont(ofSize: 22)
        heroDescriptionLabel.numberOfLines = 0
        heroDescriptionLabel.textColor = .darkGray
        
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            heroImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: 200),
            heroImageView.heightAnchor.constraint(equalToConstant: 200),
            
            imageLoadingIndicator.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor),
            imageLoadingIndicator.centerYAnchor.constraint(equalTo: heroImageView.centerYAnchor),
            
            heroNameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 20),
            heroNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            heroDescriptionLabel.topAnchor.constraint(equalTo: heroNameLabel.bottomAnchor, constant: 20),
            heroDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            heroDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
