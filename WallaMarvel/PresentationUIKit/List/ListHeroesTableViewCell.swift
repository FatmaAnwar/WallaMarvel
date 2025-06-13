import Foundation
import UIKit
import Kingfisher

final class ListHeroesTableViewCell: UITableViewCell {
    private let heroeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let heroeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        addContraints()
    }
    
    private func addSubviews() {
        addSubview(heroeImageView)
        addSubview(heroeName)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            heroeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            heroeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            heroeImageView.heightAnchor.constraint(equalToConstant: 80),
            heroeImageView.widthAnchor.constraint(equalToConstant: 80),
            heroeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            heroeName.leadingAnchor.constraint(equalTo: heroeImageView.trailingAnchor, constant: 12),
            heroeName.topAnchor.constraint(equalTo: heroeImageView.topAnchor, constant: 8),
        ])
    }
    
    func configure(viewModel: HeroCellViewModel) {
        heroeImageView.kf.setImage(with: viewModel.imageURL)
        heroeName.text = viewModel.name
        selectionStyle = .default
        
        heroeImageView.isAccessibilityElement = true
        heroeImageView.accessibilityLabel = .accHeroImage(name: viewModel.name)
        
        heroeName.isAccessibilityElement = true
        heroeName.accessibilityLabel = .accHeroDetailLabel(name: viewModel.name)
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = .accHeroCell(name: viewModel.name)
        self.accessibilityHint = .accHeroCellHint
        self.accessibilityTraits = .button
    }
}
