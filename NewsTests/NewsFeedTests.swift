//
//  NewsFeedTests.swift
//  NewsTests
//
//  Created by Moin Uddin on 5/3/2023.
//

import XCTest
@testable import News

class NewsFeedTests: NewsTests{
    /// Scenario - No news when no internet and cache.
    func test_no_news_when_no_internet_and_no_cache() async {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setNoInternet()
        
        // Then the user should see no news
        
        let newsVM = NewsViewModel(service: MockNewsService())
        
        Task.detached{
            await newsVM.fetchNews()
            XCTAssertTrue(newsVM.news.count == 0, "News feed should be empty but found \(newsVM.news.count) news")
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - Has news when no internet but cache.
    func test_has_news_when_no_internet_but_cache() {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setNoInternet()
        
        // Given cached news data available
        let cache = LRUCache<URL, NewsFeedResponse>()
        let url = RestAPIManager.newsFeed
        let response = MockNewsFeedData.news
        cache.setValue(response, forKey: url)
        
        let newsService = MockNewsService(cache: cache)
        let newsVM = NewsViewModel(service: newsService)
        
        // Then the user should see cached news
        Task.detached{
            await newsVM.fetchNews()
            XCTAssertTrue(newsVM.news.count > 0, "News feed should be empty")
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - Warning message when no internet.
    func test_warning_message_when_no_internet() {
        // Given the device has no internent connectivity
        addLaunchArguments([.noNetwork])
        
        // When a user opens the app
        app.launch()
        
        // Then the user should see warning message
        guard let errorMessage = errorMessage() else {
            XCTFail("Error message does not exist.")
            return
        }
        
        XCTAssertTrue(errorMessage.label.contains(NewsAppErrors.noInternet.localizedDescription), "Error message did not match.")
    }
    
    /// Scenario - Warning message for cache.
    func test_warning_message_when_no_internet_but_cache() {
        // Given the device has no internent connectivity
        addLaunchArguments([.noNetwork])
        
        // Given cached news data available
        addLaunchArguments([.cachedNews])
        
        // When a user opens the app
        app.launch()
        
        // Then the user should see warning message
        guard let errorMessage = errorMessage() else {
            XCTFail("Error message does not exist.")
            return
        }
        
        XCTAssertTrue(errorMessage.label.contains(Constants.Messages.cachedNewsFeed), "Error message did not match.")
    }
    
    /// Scenario - No warning message when the device has internet and showing live news feed
    func test_no_warning_message_when_the_device_has_internet() {
        // Given the device has no internent connectivity
        addLaunchArguments([.noNetwork])
        
        // Given cached news data available
        addLaunchArguments([.cachedNews])
        
        // When a user opens the app
        app.launch()
        
        // Then the user should see warning message
        guard let _ = errorMessage() else {
            return
        }
        
        XCTFail("Error message should not be displayed.")
    }
}
