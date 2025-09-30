//
//  DetailsViewController.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/15/25.
//

import UIKit
protocol ArticleListDeleteDelegate: AnyObject {
    func didDeleteArticle(_ article: ArticleList)
}
class DetailsViewController: UIViewController {
    
    //MARK: Properties
    
    var article: ArticleList?
    var closure: ((ArticleList?) -> Void?)? = nil
    var delegate: ArticleListDeleteDelegate?
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemBlue
        titleLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 35)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .black
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    var commentsTextField: UITextField = {
        let commentsTextField = UITextField()
        commentsTextField.placeholder = "Add a comment..."
        commentsTextField.borderStyle = .roundedRect
        commentsTextField.textColor = .black
        commentsTextField.translatesAutoresizingMaskIntoConstraints = false
        commentsTextField.font = .systemFont(ofSize: 17)
        return commentsTextField
    }()
    
    var articleImageView = {
        let articleImageView = UIImageView()
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.setContentHuggingPriority(.required, for: .horizontal)
        articleImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return articleImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
      // delegate?.didDeleteArticle(article!)
        
    }
    
}

//MARK: Helper functions

extension DetailsViewController {
    
    func setupUI() {
        title = "Details"
        view.backgroundColor = .systemBackground
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel,articleImageView,  descriptionLabel, commentsTextField])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 12
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backToPreviousScreen))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveComment))
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.widthAnchor.constraint(equalToConstant: 500),
            commentsTextField.heightAnchor.constraint(equalToConstant: 80),
            commentsTextField.widthAnchor.constraint(equalToConstant: 500),
            articleImageView.heightAnchor.constraint(equalToConstant: 300),
            articleImageView.widthAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    func configureData() {
        titleLabel.text = article?.author ?? "Unknown Author"
        descriptionLabel.text = article?.description ?? "No description available"
        if article?.comments != nil {
            commentsTextField.text = article?.comments
        }
    }
    
    @objc func backToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveComment() {
        article?.comments = commentsTextField.text
        guard let closure = closure else { return }
        closure(article)
        self.navigationController?.popViewController(animated: true)
    }
}
