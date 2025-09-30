//
//  CountryListViewModel.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/18/25.
//

import UIKit
protocol CountryListViewModelProtocol : AnyObject {
    var countries: [Country] { get set }
    var filteredCountries: [Country] { get set }
    var errorState: NetworkState? { get set }
    var searchController: UISearchController { get }
    func getDataFromServer(completion: ((NetworkState?) -> Void)?)
}

class CountryListViewModel: CountryListViewModelProtocol {
    var countries: [Country] = []
    var filteredCountries: [Country] = []
    var networkManager = CountryNetworkManager.shared
    var errorState: NetworkState?
    let searchController = UISearchController(searchResultsController: nil)
    
    init() {}
    
    
    func getDataFromServer(completion: ((NetworkState?) -> Void)?) {
        networkManager.getData(from: Server.CountryEndPoint.rawValue) {
            
            [weak self] fetchedState in
            guard let self = self else { return }
            
            switch fetchedState {
            case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
                errorState = fetchedState
                break
            case .success(let fetchedData):
                self.countries = networkManager.parse(data: fetchedData)
                self.filteredCountries = countries
                break
            }
            
            DispatchQueue.main.async {
                completion?(self.errorState)
            }
        }
    }
    
    func getCountry(at index: Int) -> Country {
        return filteredCountries[index]
    }
    func getCountryCount() -> Int {
        return filteredCountries.count
    }
    func getFilteredCountries() -> [Country] {
        return filteredCountries
    }
    
    func searchCountries(with query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            filteredCountries  = countries
            return
        }
        let lowercasedQuery = query.lowercased()
        filteredCountries = countries.filter {
          return  $0.name?.lowercased().contains(lowercasedQuery) ?? false || $0.capital?.lowercased().contains(lowercasedQuery) ?? false
        }
        
    }
    
    }



extension CountryListViewModel {
    var errorMessage: String {
        guard let errorState = errorState else { return "" }
        switch errorState {
        case .invalidURL:
            return "Invalid URL"
        case .errorFetchingData:
            return "Error fetching data"
        case .noDataFromServer:
            return "No data from server"
        default :
            return ""
        }
    }
}
