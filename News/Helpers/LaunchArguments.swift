//
//  LaunchArguments.swift
//  News
//
//  Created by Moin Uddin on 7/3/2023.
//

import Foundation

final enum LaunchArguments: String{
    case uiTest = "--uitest"
    case noInternet = "--no-internet"
    case cachedNews = "--cachedNews"
    
    var isActive: Bool{
        #if DEBUG
        return CommandLine.arguments.contains(self.rawValue)
        #else
        // Do not return true in Release and other mode
        return false
        #endif
    }
}
