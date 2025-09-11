//
//  MockArticleViewModel.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/9/25.
//

@testable import ArticleList

class MockArticleViewModel: ArticleViewModelProtocol{
    
    var article: [ArticleList] = []
    
    var filteredList: [ArticleList] = []
    
    func getArticlesCount() -> Int {
        article.count
    }
    
    func getArticle(at index: Int) -> ArticleList {
        if article.count > index {
            return article[index]
        }
        return ArticleList(author: "Tejasv" , description: "He is a working professional", urlToImage: "image", publishedAt: "today")
    }
    
    func getDataFromServer(closure: @escaping (() -> Void)) {
        article = []
    }
    
}
