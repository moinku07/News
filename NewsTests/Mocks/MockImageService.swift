//
//  MockImageService.swift
//  NewsTests
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation
@testable import News
import UIKit

struct MockImageService: ImageServiceProtocol {
    let cache: LRUCache<URL, Data>
    let cachePolicy: NSURLRequest.CachePolicy
    
    init(cachePolicy: NSURLRequest.CachePolicy = .returnCacheDataElseLoad, cache: LRUCache<URL, Data> = .init(maxCost: Int.max, maxCount: 1)){
        self.cachePolicy = cachePolicy
        self.cache = cache
    }
    
    func fetchImage(url: URL) async throws -> Data? {
        let cachedData = await cache.value(forKey: url)
        
        if cachePolicy == .returnCacheDataElseLoad, let data = cachedData {
            return data
        }
        
        guard MockServiceManager.shared.isServiceAvailable else {
            if let data = cachedData {
                return data
            }
            
            return nil
        }
        
        let data = UIImage(systemName: "photo")?.pngData()
        
        await cache.setValue(data, forKey: url)
        
        return UIImage(systemName: "photo")?.pngData()
    }
}
