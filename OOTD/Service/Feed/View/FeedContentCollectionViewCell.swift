//
//  FeedContentCollectionViewCell.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCollectionView: UICollectionView { }
class FeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func configure(_ feed: Feed) {
        imageView.kf.setImage(with: feed.photoUrl)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}
