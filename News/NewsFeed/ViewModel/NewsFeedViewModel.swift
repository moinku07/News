//
//  NewsFeedViewModel.swift
//  News
//
//  Created by Moin Uddin on 8/3/2023.
//

import Foundation
import UIKit

final class NewsFeedViewModel: ObservableObject {
    let service: NewsFeedServiceProtocol
    
    let cellId: StaticString = "NewsItemCell"
    let headerId: StaticString = "HeaderCell"
    
    @Published
    private(set) var sections: [NewsFeedSection] = []
    
    @Published
    private(set) var errorMessage: String = ""
    
    private var queqe = DispatchQueue(label: "NewsFeedViewModel Queue", attributes: .concurrent)
    
    init(service: NewsFeedServiceProtocol){
        self.service = service
    }
    
}

extension NewsFeedViewModel {
    func fetchNews() async {
        do{
            let response = try await service.fetchNews(url: RestAPIManager.newsFeed)
            setSections(response.assets)
        }catch{
            setSections([])
            errorMessage = (error as? NewsAppError)?.localizedDescription ?? error.localizedDescription
        }
    }
}

private extension NewsFeedViewModel {
    func setSections(_ news: [NewsAsset]){
        queqe.async{
            guard news.count > 0  else {
                self.sections = []
                return
            }
            
            let newsItemModels = news
                .sorted(by: { $0.timeStamp > $1.timeStamp })
                .map{
                    NewsItemViewModel(news: $0, service: ImageService(cachePolicy: .returnCacheDataElseLoad, cache: CacheProvider.shared.imageCache))
                }
            let section = NewsFeedSection(news: newsItemModels)
            
            self.sections = [section]
        }
    }
}

extension NewsFeedViewModel {
    
    func numberOfSections() -> Int {
        sections.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        sections[section].news.count
    }
    
    func cell(cellForItemAt indexPath: IndexPath, in collectionView: UICollectionView) -> NewsItemCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(cellId)", for: indexPath) as? NewsItemCell else {
            fatalError("dequeueReusableCell withReuseIdentifier NewsItemCell failed.")
        }
        let newsModel = sections[indexPath.section].news[indexPath.row]
        
        cell.configure(newsModel)
        
        cell.backgroundColor = .systemTeal
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    func viewForSupplementaryElement(of kind: String, at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionReusableView {
        let reusableView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(headerId)", for: indexPath)
        
        if kind == UICollectionView.elementKindSectionHeader {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = errorMessage
            
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            reusableView.addSubview(label)
        }
        
        return reusableView
    }
    
    func setErrorMessage(in collectionView: UICollectionView) {
        collectionView.backgroundView = nil
        
        guard !errorMessage.isEmpty, numberOfSections() == 0 else {
            return
        }
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = errorMessage
        label.accessibilityIdentifier = "NewsFeedErrorMessage"
        
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundView = label
    }
    
    func didSelectItem(at indexPath: IndexPath, in collectionView: UICollectionView) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let news = sections[indexPath.section].news[indexPath.row].news
        let detailVC = NewsDetailView()
        detailVC.viewModel = NewsDetailViewModel(news: news)
        Router.shared.navigate(to: detailVC)
    }
}
