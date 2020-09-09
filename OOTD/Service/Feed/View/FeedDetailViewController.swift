//
//  FeedDetailViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/09/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController, StoryboardBuildable {
    @IBOutlet weak var photoImageView: UIImageView!

    private var feed: Feed!

    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.kf.setImage(with: feed.photoUrl)
    }

    static func instantiate(feed: Feed) -> Self {
        let detailViewController = instantiate()
        detailViewController.feed = feed
        return detailViewController
    }
}
