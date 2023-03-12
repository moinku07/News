//
//  WebViewController.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation
import UIKit
import WebKit

class NewsDetailView: UIViewController, WKNavigationDelegate, WKUIDelegate{
    
    var webView: WKWebView!
    
    var viewModel: NewsDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if webView == nil{
            webView = WKWebView(frame: self.view.frame)
            webView.accessibilityIdentifier = "NewsDetailView"
        }
        
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        
        if viewModel != nil {
            title = viewModel.news.headline
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.loadWebPage(in: webView)
    }
}
