//
//  CountryViewController.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/18/25.
//
import UIKit
class CountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    let viewModel = CountryListViewModel()
    let tableView = UITableView()
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        return refreshControl
    }()
    let activationIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchCountries(with: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        tableViewSetUp()
        title = "Country List"
        view.addSubview(activationIndicatorView)
         activationIndicatorView.center = view.center
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        activationIndicatorView.startAnimating()
        viewModel.getDataFromServer { [weak self] errorState in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let _ = errorState {
                    self.showAlert(title: "Error", message: self.viewModel.errorMessage)
                } else {
                    self.tableView.reloadData()
                    self.activationIndicatorView.stopAnimating()
                }
            }
        }

    }
    
    @objc func refreshData(sender: UIRefreshControl) {
        activationIndicatorView.startAnimating()
        viewModel.getDataFromServer { [weak self] errorState in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let _ = errorState {
                    self.showAlert(title: "Error", message: self.viewModel.errorMessage)
                } else {
                    sender.endRefreshing()
                    self.tableView.reloadData()
                    self.activationIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Country"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    func tableViewSetUp() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.rowHeight = 50
        
        view.addSubview(tableView)
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCountryCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseIdentifier, for: indexPath) as! CountryCell
        cell.configure(with: viewModel.getCountry(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = viewModel.getCountry(at: indexPath.row)
        let vc = CountryDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

