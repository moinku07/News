//
//  CacheProvider.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation

struct CacheProvider{
    static var shared = CacheProvider()
    
    private init(){}
    
    let imageCache = LRUCache<URL, Data>(maxCount: 20)
    let newsCache = LRUCache<URL, NewsFeedResponse>(maxCount: 20)
}
