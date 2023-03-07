//
//  NewsFeedUITests.swift
//  NewsUITests
//
//  Created by Moin Uddin on 4/3/2023.
//

import XCTest

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
        
        guard !errorMessage.waitForExistence(timeout: existenceCheckTimeAllowance) else {
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
        
        XCTAssertTrue(errorMessage.label.contains(NewsAppErrors.noInternet.localizedDescription), "Error message did not match.")
    }
    
    /// Scenario - Warning message for cache.
    func test_warning_message_when_no_internet_but_cache() {
        // Given the device has no internent connectivity
        addLaunchArguments([.noInternet])
        
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
    
}
