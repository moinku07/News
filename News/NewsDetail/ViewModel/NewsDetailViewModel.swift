//
//  NewsDetailViewModel.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation
import WebKit

struct NewsDetailViewModel{
    var news: NewsAsset
    
    weak var webView: WKWebView?
    
    func loadWebPage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            webView?.load(URLRequest(url: news.url))
        }
    }
    
    func loadWebPage(in webView: WKWebView){
        webView.load(URLRequest(url: news.url))
    }
}
