//
//  ArticleListModel.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/9/25.
//

import Foundation

struct News: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleList]
}
struct ArticleList: Decodable {
    let author: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    var comments: String?
    
    var publishedDateOnly: String {
        guard let publishedAt = publishedAt, publishedAt.count >= 10 else { return "" }
        return String(publishedAt.prefix(10))
    }

    enum CodingKeys: String, CodingKey {
        case author, description
        case urlToImage
        case publishedAt
    }
}
