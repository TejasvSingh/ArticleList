//
//  ArticleListTests.swift
//  ArticleListTests
//
//  Created by Tejasv Singh on 9/9/25.
//

import XCTest
@testable import ArticleList

class ArticleListViewModelTests: XCTestCase {
    var articleViewModel: ArticleViewModelProtocol!
    
    override func setUpWithError() throws {
        
        articleViewModel = MockArticleViewModel()
        articleViewModel.getDataFromServer(closure:{})
        
    }
    
    override func tearDownWithError() throws {
        
        articleViewModel = nil
        
    }
    
    func testGetNumberOfRows() {
        
        XCTAssertEqual(articleViewModel.getArticlesCount(), 0)
        
    }
    
    func testSampleData() {
        
        XCTAssertNotNil(articleViewModel.getArticle(at: 0))
        XCTAssertEqual(articleViewModel.getArticle(at: 0).author, "Tejasv")
        XCTAssertEqual(articleViewModel.getArticle(at: 0).urlToImage, "image")
        XCTAssertEqual(articleViewModel.getArticle(at: 0).publishedAt, "today")

    }
    
}

