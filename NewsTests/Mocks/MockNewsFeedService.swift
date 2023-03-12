//
//  MockNewsService.swift
//  NewsTests
//
//  Created by Moin Uddin on 8/3/2023.
//

import Foundation
@testable import News

struct MockNewsFeedService: NewsFeedServiceProtocol {
    let cache: LRUCache<URL, NewsFeedResponse>
    let cachePolicy: NSURLRequest.CachePolicy
    
    init(cachePolicy: NSURLRequest.CachePolicy = .returnCacheDataElseLoad, cache: LRUCache<URL, NewsFeedResponse> = .init(maxCost: Int.max, maxCount: 1)){
        self.cachePolicy = cachePolicy
        self.cache = cache
    }
    func fetchNews(url: URL) async throws -> NewsFeedResponse {
        let cachedResponse = await cache.value(forKey: url)
        
        if cachePolicy == .returnCacheDataElseLoad, let response = cachedResponse {
            return response
        }
        
        guard MockServiceManager.shared.isServiceAvailable else {
            if let response = cachedResponse {
                return response
            }
            
            throw NewsAppError.noInternet
        }
        
        let response = MockNewsFeedData.newsResponse
        
        await cache.setValue(response, forKey: url)
        
        return response
    }
}
