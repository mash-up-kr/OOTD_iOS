//
//  TagCollectionHeaderView.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class TagCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(userName: String) {
        titleLabel.text = "\(userName)님의 스타일을\n알려주세요!"
    }
}
