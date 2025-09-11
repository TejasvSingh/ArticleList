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
    func getDataFromServer(closure: @escaping (() -> Void))
    func searchArticles(with query: String)
    func resetSearch()
}

class ArticleListViewModel: ArticleViewModelProtocol {
    var article: [ArticleList] = []
    var filteredList: [ArticleList] = []
    var networkManager = ArticleNetworkManager.shared
    
    
    let searchController = UISearchController(searchResultsController: nil)

    init() {}

    func getDataFromServer(closure: @escaping (() -> Void)) {
        networkManager.getData(from: Server.ArticlesEndPoint.rawValue) { [weak self] data in
            guard let self = self else { return }
               let fetchedList = self.networkManager.parse(data: data)
               self.article = fetchedList?.articles ?? []
               self.filteredList = self.article
               closure()
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

    func resetSearch() {
        filteredList = article
    }
}
