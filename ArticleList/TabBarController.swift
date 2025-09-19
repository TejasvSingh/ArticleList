//
//  TabBarController.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/17/25.
//
import UIKit
class TabBarController: UITabBarController, UITabBarControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        
        makeTabs()
        self.delegate = self
    }
    func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().isTranslucent = false
        tabBar.standardAppearance = appearance
    }
    func makeTabs() {
        let dashBoard = UINavigationController(rootViewController: ArticleListController())
        dashBoard.tabBarItem.title = "Dashboard"
        dashBoard.tabBarItem.image = UIImage(systemName: "house")
        let author = UINavigationController(rootViewController: AboutAuthors())
        author.tabBarItem.title = "Authors"
        author.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        let subscription = UINavigationController(rootViewController: SubscriptionViewController())
        subscription.tabBarItem.title = "Subscription"
        subscription.tabBarItem.image = UIImage(systemName: "cart")
        let profile = UINavigationController(rootViewController: ProfileViewController())
        profile.tabBarItem.title = "Profile"
        profile.tabBarItem.image = UIImage(systemName: "person.circle")
        let country = UINavigationController(rootViewController: CountryViewController())
        country.tabBarItem.title = "Country"
        country.tabBarItem.image = UIImage(systemName: "map")
        self.viewControllers = [dashBoard, country, author, subscription, profile]
        
    }
}
