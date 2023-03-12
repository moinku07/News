//
//  NewsItemCell.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import UIKit

class NewsItemCell: UICollectionViewCell {
    var viewModel: NewsItemViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ viewModel: NewsItemViewModel) {
        self.viewModel = viewModel
        
        headlineLabel.text = viewModel.news.headline
        abstractLabel.text = viewModel.news.theAbstract
        
        timeLabel.text = viewModel.timeString
        authorLabel.text = viewModel.news.byLine
        
        thumbnailImageView.image = UIImage(systemName: "photo")
        
        Task{[weak self] in
            if let imageData = await self?.viewModel.fetchImage(){
                guard let image = UIImage(data: imageData) else {
                    throw NewsAppError.parserError(reason: "Unable to parse image data.")
                }
                DispatchQueue.main.async{[weak self] in
                    self?.thumbnailImageView.image = image
                }
            }
        }
    }
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = ""
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let abstractLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = ""
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = ""
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private func setupViews(){
        // Vertical Stack view to hold the headline and abstract
        let textVStack = UIStackView()
        textVStack.axis = .vertical
        textVStack.distribution = .fill
        textVStack.alignment = .fill
        textVStack.spacing = 8
        
        textVStack.addArrangedSubview(headlineLabel)
        textVStack.addArrangedSubview(abstractLabel)
        
        let headlineHeightConstraint = headlineLabel.heightAnchor.constraint(equalToConstant: 40)
        textVStack.addConstraints([headlineHeightConstraint])
        
        // Horizontal stack view to hold the vStack and thumbnail
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .fill
        hStack.spacing = 8
        
        hStack.addArrangedSubview(textVStack)
        hStack.addArrangedSubview(thumbnailImageView)
        
        let thumbnailImageViewWidthConstraint = thumbnailImageView.widthAnchor.constraint(equalToConstant: 100)
        hStack.addConstraints([thumbnailImageViewWidthConstraint])
        
        let timeHStack = UIStackView()
        timeHStack.axis = .horizontal
        timeHStack.distribution = .fill
        timeHStack.alignment = .leading
        timeHStack.spacing = 8
        
        timeHStack.addArrangedSubview(timeLabel)
        timeHStack.addArrangedSubview(authorLabel)
        
        let newsVStack = UIStackView()
        newsVStack.axis = .vertical
        newsVStack.distribution = .fill
        newsVStack.alignment = .fill
        newsVStack.spacing = 4
        
        newsVStack.addArrangedSubview(hStack)
        newsVStack.addArrangedSubview(timeHStack)
        
        let timeHStackConstraint = timeHStack.heightAnchor.constraint(equalToConstant: 15)
        newsVStack.addConstraints([timeHStackConstraint])
        
        // Add hStack in contentview and setup constraints
        newsVStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newsVStack)
        NSLayoutConstraint.activate([
            newsVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            newsVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            newsVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            newsVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}
