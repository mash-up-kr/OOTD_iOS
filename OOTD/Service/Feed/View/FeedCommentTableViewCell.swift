//
//  FeedCommentTableViewCell.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(_ comment: FeedComment) {
        nicknameLabel.text = comment.userNickname
        messageLabel.text = comment.message
        dateLabel.text = comment.daysFromToday
    }
}
