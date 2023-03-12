//
//  NewsFeedTests.swift
//  NewsTests
//
//  Created by Moin Uddin on 5/3/2023.
//

import XCTest
@testable import News

class NewsFeedTests: NewsTests{
    /// Scenario - Warning message when no internet.
    func test_warning_message_when_no_internet() {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setServiceNotAvailable()
        
        // Then the user should see warning message
        let newsVM = NewsFeedViewModel(service: MockNewsFeedService())
        
        Task.detached {
            await newsVM.fetchNews()
            let errorMessage = newsVM.errorMessage
            XCTAssertTrue(errorMessage == NewsAppError.noInternet.localizedDescription, "Error message did not match.")
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - No warning message when the device has internet and showing live news feed
    func test_no_warning_message_when_the_device_has_internet() {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has internent connectivity
        MockServiceManager.shared.setServiceAvailable()
        
        // Then the user should see no warning message
        let newsVM = NewsFeedViewModel(service: MockNewsFeedService())
        
        Task.detached {
            await newsVM.fetchNews()
            let errorMessage = newsVM.errorMessage
            
            XCTAssertTrue(errorMessage.isEmpty, "Error message should be empty.")
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - No news when no internet and cache.
    func test_no_news_when_no_internet_and_no_cache() async {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setServiceNotAvailable()
        
        // Then the user should see no news
        
        let newsVM = NewsFeedViewModel(service: MockNewsFeedService())
        
        newsVM.$sections
            .dropFirst() // drop the initial value
            .sink { sections in
                XCTAssertTrue(sections.count == 0, "News feed should be empty but found \(sections.count) news")
                
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        Task.detached {
            await newsVM.fetchNews()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - Has news when no internet but cache.
    func test_has_news_when_no_internet_but_cache() async {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setServiceNotAvailable()
        
        // Given cached news data available
        let cache = LRUCache<URL, NewsFeedResponse>()
        let url = RestAPIManager.newsFeed
        let response = MockNewsFeedData.newsResponse
        await cache.setValue(response, forKey: url)
        
        let newsService = MockNewsFeedService(cache: cache)
        let newsVM = NewsFeedViewModel(service: newsService)
        
        newsVM.$sections
            .dropFirst() // drop the initial value
            .sink { sections in
                XCTAssertTrue(sections.count > 0, "News feed should not be empty.")
                
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        // Then the user should see cached news
        Task.detached{
            await newsVM.fetchNews()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - Display the latest article first in the list
    func test_latest_news_first() async {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setServiceNotAvailable()
        
        // Given cached news data available
        let cache = LRUCache<URL, NewsFeedResponse>()
        let url = RestAPIManager.newsFeed
        let response = MockNewsFeedData.newsResponse
        await cache.setValue(response, forKey: url)
        
        let newsService = MockNewsFeedService(cache: cache)
        let newsVM = NewsFeedViewModel(service: newsService)
        
        newsVM.$sections
            .dropFirst() // drop the initial value
            .sink { sections in
                guard sections.count > 0 else { return }
                
                let sortedNewsVMs = sections[0].news.sorted(by: { $0.news.timeStamp > $1.news.timeStamp })
                
                XCTAssertTrue(sections[0].news == sortedNewsVMs, "News articles are not sorted by timeStamp DESC.")
                
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        // Then the user should see cached news
        Task.detached{
            await newsVM.fetchNews()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
}
