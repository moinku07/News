//
//  ImageAsset.swift
//  News
//
//  Created by Moin Uddin on 8/3/2023.
//

import Foundation

struct ImageAsset: Codable, Identifiable, Hashable {
    enum AssetType: String, Codable{
        case image = "IMAGE"
    }

    enum ImageType: String, Codable {
        case wideLandscape
        case thumbnail
        case afrArticleLead
        case afrArticleInline
        case articleLeadWide
        case afrIndexLead
        case landscape
    }
    
    var id: Int64
    var url: String
    var type: ImageType
    var width: Double
    var height: Double
    var assetType: AssetType
    var timeStamp: TimeInterval
}
