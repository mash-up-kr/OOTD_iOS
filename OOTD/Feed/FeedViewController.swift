//
//  FeedViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/24.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, StoryboardBuildable {
    
    @IBOutlet weak var filterCollectionView: FeedFilterCollectionView!
    @IBOutlet weak var contentCollectionView: FeedContentCollectionView!

    private let filters = FeedFilter.samples
    private let contents = FeedContent.samples
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView is FeedFilterCollectionView {
            return filters.count
        }
        
        if collectionView is FeedContentCollectionView {
            return contents.count
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView is FeedFilterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedFilterCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedFilterCollectionViewCell
            cell.configure(filters[indexPath.item])
            return cell
        }
        
        if collectionView is FeedContentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedContentCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedContentCollectionViewCell
            cell.configure(contents[indexPath.item])
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "NONE", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView is FeedContentCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let width = (collectionView.bounds.width - layout.minimumInteritemSpacing) / 2
            return CGSize(width: width, height: width)
        }
        
        return .zero
    }
}
