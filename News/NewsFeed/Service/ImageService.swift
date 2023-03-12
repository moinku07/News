//
//  ImageService.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation
import UIKit

struct ImageService: ImageServiceProtocol {
    let cache: LRUCache<URL, Data>
    let cachePolicy: NSURLRequest.CachePolicy
    
    init(cachePolicy: NSURLRequest.CachePolicy = .returnCacheDataElseLoad, cache: LRUCache<URL, Data> = .init(maxCost: Int.max, maxCount: 1)){
        self.cachePolicy = cachePolicy
        self.cache = cache
    }
    
    
    func fetchImage(url: URL) async throws -> Data? {
        guard ServiceManager.shared.isServiceAvailable else {
            if cachePolicy == .returnCacheDataElseLoad, let data = await cache.value(forKey: url) {
                return data
            }

            return nil
        }
        
        let imageData = await cache.value(forKey: url)
        
        if cachePolicy == .returnCacheDataElseLoad, let data = imageData {
            return data
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NewsAppError.noData
        }
        
        await cache.setValue(data, forKey: url)
        
        return data
    }
}

