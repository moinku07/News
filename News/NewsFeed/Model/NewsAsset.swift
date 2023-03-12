//
//  NewsAsset.swift
//  News
//
//  Created by Moin Uddin on 8/3/2023.
//

import Foundation

struct NewsAsset: Codable, Hashable, Identifiable {
    var id: Int64
    var url: URL
    var lastModified: TimeInterval
    var sponsored: Bool
    var headline: String
    var indexHeadline: String
    var tabletHeadline: String
    var theAbstract: String
    var byLine: String
    var acceptComments: Bool
    var numberOfComments: Int64
    var relatedImages: [ImageAsset]
    var timeStamp: TimeInterval
    var authors: [Author]
}
