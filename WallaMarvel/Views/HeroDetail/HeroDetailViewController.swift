//
//  HeroDetailViewController.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 08/06/2025.
//

import Foundation
import UIKit
import Kingfisher

final class HeroDetailViewController: UIViewController {
    
    var viewModel: HeroDetailViewModelProtocol!
    private let heroImageView = UIImageView()
    private let heroNameLabel = UILabel()
    private let heroDescriptionLabel = UILabel()
    
    private let imageLoadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [heroImageView, heroNameLabel, heroDescriptionLabel, imageLoadingIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        heroNameLabel.font = .boldSystemFont(ofSize: 22)
        heroDescriptionLabel.numberOfLines = 0
        heroDescriptionLabel.textColor = .darkGray
        
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            heroImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: 200),
            heroImageView.heightAnchor.constraint(equalToConstant: 200),
            
            imageLoadingIndicator.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor),
            imageLoadingIndicator.centerYAnchor.constraint(equalTo: heroImageView.centerYAnchor),
            
            heroNameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 20),
            heroNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            heroDescriptionLabel.topAnchor.constraint(equalTo: heroNameLabel.bottomAnchor, constant: 20),
            heroDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            heroDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

extension HeroDetailViewController: HeroDetailViewModelDelegate {
    func displayHero(name: String, description: String, imageURL: URL?) {
        heroNameLabel.text = name
        heroDescriptionLabel.text = description.isEmpty ? "No description available." : description
        
        if let imageURL = imageURL {
            imageLoadingIndicator.startAnimating()
            heroImageView.kf.setImage(with: imageURL) { _ in
                self.imageLoadingIndicator.stopAnimating()
            }
        }
    }
}
