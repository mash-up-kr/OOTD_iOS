//
//  FeedTagCollectionViewCell.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedTagCollectionView: UICollectionView { }
class FeedTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(_ tag: Tag) {
        titleLabel.text = tag.name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
