//
//  SubscriptionViewController.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/17/25.
//

import UIKit
class SubscriptionViewController: UIViewController {
    let authorLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        label.text = "Your subscription is active. You can manage your subscription settings in the settings app."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(authorLabel)
        
    }
}
