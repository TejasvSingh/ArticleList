//
//  ArticleListController.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/9/25.
//

import UIKit

class ArticleListController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    var tableView = UITableView()
    let viewModel = ArticleListViewModel()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        setupTableView()

        viewModel.getDataFromServer { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ArticleListCell.self, forCellReuseIdentifier: ArticleListCell.reuseIdentifier)
    }
    
    func configureSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.backgroundColor = .systemGray6
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getArticlesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ArticleListCell.reuseIdentifier,
            for: indexPath
        ) as! ArticleListCell
        cell.configure(with: viewModel.getArticle(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


extension ArticleListController {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchArticles(with: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.resetSearch()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
