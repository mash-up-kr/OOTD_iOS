//
//  TagCollectionViewCell.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = UIColor.blueKey
                titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
            } else {
                contentView.backgroundColor = UIColor.grey04
                titleLabel.font = UIFont.systemFont(ofSize: titleLabel.font.pointSize)
            }
        }
    }
    
    func configure(_ tag: Tag) {
        titleLabel.text = tag.title
    }
}
