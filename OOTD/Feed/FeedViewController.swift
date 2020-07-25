//
//  FeedViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/24.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

struct FeedFilter {
    let title: String
}

class FeedViewController: UIViewController, StoryboardBuildable {
    
    @IBOutlet weak var filterCollectionView: FeedFilterCollectionView!

    private let filters: [FeedFilter] = [FeedFilter(title: "스포티"), FeedFilter(title: "보헤미안"), FeedFilter(title: "차이나타운"),
                                         FeedFilter(title: "클래식"), FeedFilter(title: "스트릿"), FeedFilter(title: "러블리"),
                                         FeedFilter(title: "캐주얼"), FeedFilter(title: "클래식"), FeedFilter(title: "클래식")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCollectionView.allowsMultipleSelection = true
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView is FeedFilterCollectionView {
            return filters.count
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView is FeedFilterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedFilterCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedFilterCollectionViewCell
            cell.configure(filters[indexPath.item])
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "NONE", for: indexPath)
    }
}
