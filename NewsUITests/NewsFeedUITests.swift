//
//  NewsFeedUITests.swift
//  NewsUITests
//
//  Created by Moin Uddin on 4/3/2023.
//

import XCTest
@testable import News

class NewsFeedUITests: NewsUITests {
    func newsFeedView() -> XCUIElement? {
        let newsFeedCollectionView = app.collectionViews["NewsFeed"].firstMatch
        
        guard newsFeedCollectionView.waitForExistence(timeout: existenceCheckTimeAllowance) else {
            XCTFail("NewsFeed does not exist.")
            return nil
        }
        
        return newsFeedCollectionView
    }
    
    func errorMessage() -> XCUIElement? {
        guard let newsFeedView = newsFeedView() else {
            return nil
        }
        
        let errorMessage = newsFeedView.staticTexts["NewsFeedErrorMessage"].firstMatch
        
        guard errorMessage.waitForExistence(timeout: existenceCheckTimeAllowance) else {
            return nil
        }
        
        return errorMessage
    }
    
    /// Scenario - No news when no internet and cache.
    func test_no_news_when_no_internet_and_no_cache() {
        // Given the device has no internent connectivity
        addLaunchArguments([.noInternet])
        
        // When a user opens the app
        app.launch()
        
        // Then the user should see no news
        
        guard let newsFeedView = newsFeedView() else {
            return
        }
        
        let newsFeedCount = newsFeedView.cells.count
        
        XCTAssertTrue(newsFeedCount == 0, "News feed should be empty but found \(newsFeedCount) news")
    }
    
    /// Scenario - Has news when no internet but cache.
    func test_has_news_when_no_internet_but_cache() {
        // Given the device has no internent connectivity
        addLaunchArguments([.noInternet])
        
        // Given cached news data available
        addLaunchArguments([.cachedNews])
        
        // When a user opens the app
        app.launch()
        
        // Then the user should see cached news
        guard let newsFeedView = newsFeedView() else {
            return
        }
        
        XCTAssertTrue(newsFeedView.cells.count > 0, "News feed should not be empty.")
    }
    
    /// Scenario - Warning message when no internet.
    func test_warning_message_when_no_internet() {
        // Given the device has no internent connectivity
        addLaunchArguments([.noInternet])
        
        // When a user opens the app
        app.launch()
        
        // Then the user should see warning message
        guard let errorMessage = errorMessage() else {
            XCTFail("Error message does not exist.")
            return
        }
        
        XCTAssertTrue(errorMessage.label.contains(NewsAppError.noInternet.localizedDescription), "Error message did not match.")
    }
    
    /// Scenario - No warning message when the device has internet and showing live news feed
    func test_no_warning_message_when_the_device_has_internet() {
        // Given the device has no internent connectivity
        addLaunchArguments([.noInternet])
        
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
    
    /// Scenario - Tapping a article item opens the news
    func test_open_news_detail_view() {
        addLaunchArguments([.noInternet])
        addLaunchArguments([.cachedNews])
        
        app.launch()
        
        // When the user tap on a news article
        let newsFeedView = newsFeedView()!
        let newsArticle = newsFeedView.cells.element(boundBy: Int.random(in: 0...newsFeedView.cells.count))
        newsArticle.tap()
        
        // Then the user should see news detail view
        let newsDetailView = app.webViews["NewsDetailView"].firstMatch
        
        guard newsDetailView.waitForExistence(timeout: existenceCheckTimeAllowance) else {
            XCTFail("News detail view did not present.")
            
            return
        }
    }
}
