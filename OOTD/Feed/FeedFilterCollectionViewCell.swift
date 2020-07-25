//
//  FeedFilterCollectionViewCell.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedFilterCollectionView: UICollectionView { }
class FeedFilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(_ filter: FeedFilter) {
        titleLabel.text = filter.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
