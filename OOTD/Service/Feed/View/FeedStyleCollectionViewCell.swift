//
//  FeedStyleCollectionViewCell.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedStyleCollectionView: UICollectionView { }
class FeedStyleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(_ style: Style) {
        titleLabel.text = style.name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
