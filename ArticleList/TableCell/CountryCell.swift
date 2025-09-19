//
//  CountryCell.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/18/25.
//

import UIKit
class CountryCell: UITableViewCell {
    static let reuseIdentifier = "CountryCell"
    let countryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var countryCapitalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let codeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let regionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    func setupUI() {
        contentView.addSubview(countryNameLabel)
        contentView.addSubview(countryCapitalLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(regionLabel)
        
        NSLayoutConstraint.activate([
            countryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            countryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            countryNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            countryCapitalLabel.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 4),
            countryCapitalLabel.leadingAnchor.constraint(equalTo: countryNameLabel.leadingAnchor),
            
            regionLabel.topAnchor.constraint(equalTo: countryNameLabel.topAnchor),
            regionLabel.leadingAnchor.constraint(equalTo: countryNameLabel.trailingAnchor, constant: 16),
            
            codeLabel.topAnchor.constraint(equalTo: countryNameLabel.topAnchor),
            codeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
        ])
    }
    
    func configure(with viewModel: Country) {
        countryNameLabel.text = viewModel.name
        countryCapitalLabel.text = viewModel.capital
        codeLabel.text = viewModel.code
        regionLabel.text = viewModel.region
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
