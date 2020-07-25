//
//  FeedFilterCollectionViewCell.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

extension UIColor {
    static let grey04 = UIColor(named: "grey04")!
    static let blueKey = UIColor(named: "blueKey")!
}

class FeedFilterCollectionView: UICollectionView { }

class FeedFilterCollectionViewCell: UICollectionViewCell {
    
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 2
    }
    
    func configure(_ filter: FeedFilter) {
        titleLabel.text = filter.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
