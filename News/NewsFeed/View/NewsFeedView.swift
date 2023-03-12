//
//  NewsFeedView.swift
//  News
//
//  Created by Moin Uddin on 12/3/2023.
//

import UIKit
import Combine

class NewsFeedView: UIViewController{
    let viewModel: NewsFeedViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NewsItemCell.self, forCellWithReuseIdentifier: "\(viewModel.cellId)")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(viewModel.headerId)")
        
        collectionView.accessibilityIdentifier = "NewsFeed"
        
        return collectionView
    }()
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Top Stories"
        
        viewModel
            .$sections
            .receive(on: DispatchQueue.main)
            .sink{[weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel
            .$errorMessage
            .receive(on: DispatchQueue.main)
            .sink{[weak self] errorMessage in
                self?.collectionView.reloadData()
                
                if let collectionView = self?.collectionView{
                    self?.viewModel.setErrorMessage(in: collectionView)
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task{
            await viewModel.fetchNews()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.invalidateLayout()
    }
}

extension NewsFeedView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath, in: collectionView)
    }
}


extension NewsFeedView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewModel.cell(cellForItemAt: indexPath, in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        viewModel.viewForSupplementaryElement(of: kind, at: indexPath, in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 20)
    }
}

extension NewsFeedView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width - 20, height: 120)
    }
}
