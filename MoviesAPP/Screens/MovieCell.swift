//
//  MovieCell.swift
//  MoviesAPP
//
//  Created by Igor Cotrim on 21/10/24.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurView
    }()
    
    private lazy var posterView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, genresLabel, ratingStackView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImageView, ratingLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = .yellow
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Movie) {
        titleLabel.text = model.name
        genresLabel.text = model.genres?.joined(separator: ", ")
        ratingLabel.text = model.rating?.average?.toString()
        
        guard let image = model.image?.medium, let imageURL = URL(string: image) else { return }
        
        posterView.kf.setImage(with: imageURL)
    }
}

// MARK: - ViewCode
extension MovieCell: ViewCode {
    func buildHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(blurView)
        containerView.addSubview(stackView)
        containerView.addSubview(posterView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            posterView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterView.widthAnchor.constraint(equalToConstant: 100),
            posterView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 16),
            stackView.trailingAnchor
                .constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            blurView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
    }
    
    func applyAdditionalChanges() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}
