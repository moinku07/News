//
//  ImageServiceProtocol.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation

protocol ImageServiceProtocol {
    var cache: LRUCache<URL, Data> { get }
    var cachePolicy: NSURLRequest.CachePolicy { get }
    
    func fetchImage(url: URL) async throws -> Data?
}
