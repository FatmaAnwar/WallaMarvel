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
    private var contentView: HeroDetailView { view as! HeroDetailView }

    override func loadView() {
        view = HeroDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
}

extension HeroDetailViewController: HeroDetailViewModelDelegate {
    func displayHero(name: String, description: String, imageURL: URL?) {
        contentView.heroNameLabel.text = name
        contentView.heroDescriptionLabel.text = description.isEmpty ? "No description available." : description

        if let imageURL = imageURL {
            contentView.imageLoadingIndicator.startAnimating()
            contentView.heroImageView.kf.setImage(with: imageURL) { _ in
                self.contentView.imageLoadingIndicator.stopAnimating()
            }
        }
    }
}
