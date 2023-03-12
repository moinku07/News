//
//  NewsItemViewModel.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import Foundation

struct NewsItemViewModel: Equatable {
    static func == (lhs: NewsItemViewModel, rhs: NewsItemViewModel) -> Bool {
        lhs.news == rhs.news
    }
    
    var news: NewsAsset
    
    var service: ImageServiceProtocol = ImageService()
    
    var author: String {
        return news.authors.first?.name ?? ""
    }
    
    var timeString: String {
        var timeString = ""
        let newsDate = Date(timeIntervalSince1970: news.timeStamp/1000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma dd/MM/yyyy"
        timeString = dateFormatter.string(from: newsDate)
        
        let calendarComponents = Calendar.current.dateComponents([.hour, .minute], from: newsDate, to: Date.now)
        
        guard let hour = calendarComponents.hour, hour < 24 else {
            return timeString
        }
        
        guard hour < 1 else {
            timeString = "\(hour)h"
            return timeString
        }
        
        guard let minute = calendarComponents.minute else {
            return timeString
        }
        
        guard minute > 0 else {
            timeString = "now"
            return timeString
        }
        
        timeString = "\(minute)m"
        
        return timeString
    }
}

extension NewsItemViewModel {
    func fetchImage() async -> Data? {
        guard let urlString = news.relatedImages.first(where: { $0.type == .thumbnail })?.url,
              let url = URL(string: urlString) else {
            return nil
        }
        do{
            let data = try await service.fetchImage(url: url)
            return data
        }catch{
            print((error as? NewsAppError)?.localizedDescription ?? error.localizedDescription)
        }
        
        return nil
    }
}
