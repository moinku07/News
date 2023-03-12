//
//  Author.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation

struct Author: Codable, Hashable, Identifiable {
    let id: UUID = UUID()
    
    var name: String
    var title: String
    var email: String
}
