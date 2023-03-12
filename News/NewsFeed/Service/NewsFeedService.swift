//
//  NewsFeedService.swift
//  News
//
//  Created by Moin Uddin on 8/3/2023.
//

import Foundation

struct NewsFeedService: NewsFeedServiceProtocol {
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
        
        guard ServiceManager.shared.isServiceAvailable else {
            if let response = cachedResponse {
                return response
            }
            
            throw NewsAppError.noInternet
        }
        
        let request = URLRequest(url: url)
        let data = try await URLSession.shared.data(for: request).0
        
        let response = try JSONDecoder().decode(NewsFeedResponse.self, from: data)
        
        await cache.setValue(response, forKey: url)
        
        return response
    }
}
