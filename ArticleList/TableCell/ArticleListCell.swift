//
//  ArticleListCell.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/9/25.
//

import UIKit

class ArticleListCell: UITableViewCell {
    static let reuseIdentifier = "ArticleListCell"
    

    var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .blue
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    var imageLabel: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var publishedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    let shareIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "square.and.arrow.up"))
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ArticleListCell {
    private func setupUI() {
        let imageSize: CGFloat = 88
        
        contentView.addSubview(authorLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(publishedDateLabel)
        contentView.addSubview(imageLabel)
        contentView.addSubview(shareIcon)
        
        NSLayoutConstraint.activate([
            imageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageLabel.widthAnchor.constraint(equalToConstant: imageSize),
            imageLabel.heightAnchor.constraint(equalToConstant: imageSize),
            imageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: imageLabel.leadingAnchor, constant: -12),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: imageLabel.leadingAnchor, constant: -12),
            
            shareIcon.centerYAnchor.constraint(equalTo: publishedDateLabel.centerYAnchor),
            shareIcon.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            shareIcon.widthAnchor.constraint(equalToConstant: 18),
            shareIcon.heightAnchor.constraint(equalToConstant: 18),
            
            publishedDateLabel.leadingAnchor.constraint(equalTo: shareIcon.trailingAnchor, constant: 6),
            publishedDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            publishedDateLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
            publishedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    
    func configure(with viewModel: ArticleList) {
        imageLabel.image = UIImage(systemName: "photo") // placeholder
        
        if let urlString = viewModel.urlToImage,
           let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self,
                      let data = data,
                      error == nil,
                      let img = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageLabel.image = img
                }
            }.resume()
        }
        
        let fullDate = viewModel.publishedAt
        let onlyDate = fullDate?.split(separator: "T").first.map(String.init) ?? fullDate
        publishedDateLabel.text = onlyDate
        
        descriptionLabel.text = viewModel.description
        authorLabel.text = viewModel.author
    }
}
