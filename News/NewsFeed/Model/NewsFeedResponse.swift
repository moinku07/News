//
//  NewsFeedResponse.swift
//  News
//
//  Created by Moin Uddin on 8/3/2023.
//

import Foundation

struct NewsFeedResponse: Codable, Hashable, Identifiable {
    var id: Int64
    var displayName: String
    
    var assets: [NewsAsset]
}
