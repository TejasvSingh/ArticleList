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
    var refreshControl = UIRefreshControl()
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private var coordinatorFlowDelegate: NavigationControllerProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.addSubview(activityIndicatorView)
        configureSearchController()
        
        
        activityIndicatorView.center = view.center
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
//            [tableView.topAnchor.constraint(equalTo: view.topAnchor),
//             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               [ activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ]
        )
        activityIndicatorView.startAnimating( )
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        viewModel.getDataFromServer { [weak self] errorState in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.activityIndicatorView.stopAnimating()
                if let _ = errorState {
                    self.showAlert(title: "Error", message: self.viewModel.errorMessage)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
        
        
        coordinatorFlowDelegate = NavigationController( navigationController: navigationController)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        activityIndicatorView.startAnimating()
        viewModel.getDataFromServer { [weak self] errorState in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.activityIndicatorView.stopAnimating()
                print("called api")
                     sender.endRefreshing()
                     self.tableView.reloadData()
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleListCell.self, forCellReuseIdentifier: ArticleListCell.reuseIdentifier)
        
    }
    
    func configureSearchController() {
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.backgroundColor = .systemGray6
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
      //  navigationController?.navigationBar.prefersLargeTitles = true
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

extension ArticleListController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedArticle = viewModel.getArticle(at: indexPath.row)
//        let closure : ((ArticleList?) -> Void)? = { [weak self] updatedArticle in
//            guard let self = self, let updatedArticle = updatedArticle else { return }
//            self.viewModel.updateArticleList(row: indexPath.row, updatedArticle: updatedArticle)
//            DispatchQueue.main.async{
//                self.tableView.reloadRows(at: [indexPath], with: .none)
//            }
//        }
//        coordinatorFlowDelegate?.showDetailScreen(article: selectedArticle, closure: closure)
        
        let detailsViewController = DetailsViewController()
        detailsViewController.article = selectedArticle
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension ArticleListController: ArticleListDeleteDelegate {
    func didDeleteArticle(_ article: ArticleList) {
      //  self.viewModel.article.removeAll { $0.author == article.author }
        self.viewModel.filteredList.removeAll { $0.author == article.author }
        tableView.reloadData()
    }
    
   
}


