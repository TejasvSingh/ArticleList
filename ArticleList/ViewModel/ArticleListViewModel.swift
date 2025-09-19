//
//  ArticleListViewModel.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/9/25.
//

import UIKit

protocol ArticleViewModelProtocol {
    var article: [ArticleList] { get set }
    var filteredList: [ArticleList] { get set }
    func getArticlesCount() -> Int
    func getArticle(at index: Int) -> ArticleList
    func getDataFromServer(completion: ((NetworkState?) -> Void)?)
    func searchArticles(with query: String)
    func resetSearch()
}

class ArticleListViewModel: ArticleViewModelProtocol {
    var article: [ArticleList] = []
    var filteredList: [ArticleList] = []
    var networkManager = ArticleNetworkManager.shared
    var errorState: NetworkState?
    
    let searchController = UISearchController(searchResultsController: nil)

    init() {}

    func getDataFromServer(completion: ((NetworkState?) -> Void)?) {
        
        networkManager.getData(from: Server.ArticlesEndPoint.rawValue) {
            
            [weak self] fetchedState in
            guard let self = self else { return }
            
            switch fetchedState {
            case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
                errorState = fetchedState
                break
            case .success(let fetchedData):
                self.article = networkManager.parse(data: fetchedData)
                self.filteredList = article
                break
            }
            
            DispatchQueue.main.async {
                completion?(self.errorState)
            }
        }
    }

    func getArticlesCount() -> Int {
        return filteredList.count
    }

    func getArticle(at index: Int) -> ArticleList {
        return filteredList[index]
    }

    func getTitle(at index: Int) -> String {
        filteredList[index].author ?? ""
    }

    func searchArticles(with query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            filteredList = article
            return
        }
        let lower = trimmed.lowercased()
        filteredList = article.filter { item in
            let authorMatch = (item.author?.lowercased().contains(lower) ?? false)
            let descMatch   = (item.description?.lowercased().contains(lower) ?? false)
            return authorMatch || descMatch
        }
    }
    
    func updateArticleList(row: Int, updatedArticle: ArticleList) {
        article[row] = updatedArticle
        filteredList[row] = updatedArticle
    }

    func resetSearch() {
        filteredList = article
    }
}


extension ArticleListViewModel {
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
