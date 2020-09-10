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

extension FeedDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feed.tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTagCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedTagCollectionViewCell
        cell.configure(feed.tags[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        return layout.estimatedItemSize
    }
}
