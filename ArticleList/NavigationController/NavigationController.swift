//
//  NavigationController.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/15/25.
//

import UIKit
protocol NavigationControllerProtocol {
    func showDetailScreen(article: ArticleList?, closure: ((ArticleList?) -> Void)?)
}

final class NavigationController: NavigationControllerProtocol{
    var navigationController: UINavigationController?
    private let networkClient: ArticleNetwork
    init(networkClient: ArticleNetwork = ArticleNetworkManager(), navigationController: UINavigationController? = nil) {
        self.networkClient = networkClient
        self.navigationController = navigationController
    }
    func showDetailScreen(article : ArticleList?, closure: ((ArticleList?) -> Void)?) {
        guard let navigationController = navigationController else { return }
        let detailsViewController = DetailsViewController()
        detailsViewController.article = article
        detailsViewController.closure = closure
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
