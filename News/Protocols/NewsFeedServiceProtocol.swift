//
//  NewsServiceProtocol.swift
//  News
//
//  Created by Moin Uddin on 8/3/2023.
//

import Foundation

protocol NewsFeedServiceProtocol {
    var cache: LRUCache<URL, NewsFeedResponse> { get }
    var cachePolicy: NSURLRequest.CachePolicy { get }
    
    func fetchNews(url: URL) async throws -> NewsFeedResponse
}
