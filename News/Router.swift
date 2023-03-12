//
//  Routing.swift
//  News
//
//  Created by Moin Uddin on 9/3/2023.
//

import Foundation
import UIKit

struct Router{
    static var shared: Router = Router()
    
    private init(){}
    
    public lazy var rootView: UIViewController = {
        if !LaunchArguments.uiTest.isActive {
            ServiceManager.shared.startNetworkMonitoring()
        }
        
        if LaunchArguments.uiTest.isActive, LaunchArguments.noInternet.isActive{
            ServiceManager.shared.stopNetworkMonitoring()
            ServiceManager.shared.setServiceNotAvailable()
        }
        
        let newsService = NewsFeedService(cache: CacheProvider.shared.newsCache)
        
        if LaunchArguments.uiTest.isActive, LaunchArguments.cachedNews.isActive{
            let url = RestAPIManager.newsFeed
            let response = MockNewsFeedData.newsResponse
            Task{
                await CacheProvider.shared.newsCache.setValue(response, forKey: url)
            }
        }
        
        let newsVC = NewsFeedView(viewModel: NewsFeedViewModel(service: newsService))
        return UINavigationController(rootViewController: newsVC)
    }()
    
    mutating func navigate(to viewController: UIViewController) {
        (rootView as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
}

private extension Router{
}
