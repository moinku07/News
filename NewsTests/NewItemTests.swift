//
//  NewItemTests.swift
//  NewsTests
//
//  Created by Moin Uddin on 12/3/2023.
//

import XCTest
@testable import News
import UIKit

class NewItemTests: NewsTests{
    /// Scenario - Image download fails when device no internet
    func test_no_image_when_no_internet() async {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setServiceNotAvailable()
        
        // Then the image download fails
        let newsItemVM = NewsItemViewModel(news: MockNewsFeedData.newsResponse.assets.randomElement()!, service: MockImageService())
        
        Task.detached {
            let data = await newsItemVM.fetchImage()
            
            XCTAssertTrue(data == nil, "Data should be nil")
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - Image download completes when device has internet
    func test_has_image_when_device_has_internet() async {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setServiceAvailable()
        
        // Then the image is downloaded
        let newsItemVM = NewsItemViewModel(news: MockNewsFeedData.newsResponse.assets.randomElement()!, service: MockImageService())
        
        Task.detached {
            let data = await newsItemVM.fetchImage()
            
            XCTAssertTrue(data != nil, "Data should not be nil")
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - Cached image when device has no internet but cache
    func test_has_image_when_no_internet_but_cache() async {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has no internent connectivity
        MockServiceManager.shared.setServiceNotAvailable()
        
        // Given cached image data available
        let cache = LRUCache<URL, Data>()
        let newsItem = MockNewsFeedData.newsResponse.assets.randomElement()!
        let urlString = newsItem.relatedImages.first(where: { $0.type == .thumbnail })!.url
        let url = URL(string: urlString)!
        let imageData = UIImage(systemName: "photo")!.pngData()!
        
        await cache.setValue(imageData, forKey: url)
        
        let imageService = MockImageService(cache: cache)
        
        // Then the cached image should be available
        let newsItemVM = NewsItemViewModel(news: newsItem, service: imageService)
        
        Task.detached {
            let data = await newsItemVM.fetchImage()
            
            XCTAssertTrue(data != nil, "Data should not be nil")
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
    
    /// Scenario - Cached image when device has internet and cache
    func test_has_image_when_device_has_internet_and_cache() async {
        let exp = XCTestExpectation(description: "\(#function)")
        
        // Given the device has internent connectivity
        MockServiceManager.shared.setServiceAvailable()
        
        // Given cached image data available
        let cache = LRUCache<URL, Data>()
        let newsItem = MockNewsFeedData.newsResponse.assets.randomElement()!
        let urlString = newsItem.relatedImages.first(where: { $0.type == .thumbnail })!.url
        let url = URL(string: urlString)!
        let imageData = UIImage(systemName: "photo")!.pngData()!
        
        await cache.setValue(imageData, forKey: url)
        
        let imageService = MockImageService(cache: cache)
        
        // Then the cached image should be available
        let newsItemVM = NewsItemViewModel(news: newsItem, service: imageService)
        
        Task.detached {
            let data = await newsItemVM.fetchImage()
            
            XCTAssertTrue(data == imageData, "Data should not be nil")
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: executionTimeAllowance)
    }
}
