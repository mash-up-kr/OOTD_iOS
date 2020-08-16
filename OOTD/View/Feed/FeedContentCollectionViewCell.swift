//
//  FeedContentCollectionViewCell.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedContentCollectionView: UICollectionView { }
class FeedContentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func configure(_ content: Feed) {
        imageView.backgroundColor = content.color
    }
}
