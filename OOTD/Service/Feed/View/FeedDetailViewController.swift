//
//  FeedDetailViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/09/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController, StoryboardBuildable {
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    private var feed: Feed!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNicknameLabel.text = feed.nickname
        photoImageView.kf.setImage(with: feed.photoUrl)
        temperatureLabel.text = "\(feed.temperature)°"
        bodyLabel.text = feed.message
    }

    static func instantiate(feed: Feed) -> Self {
        let detailViewController = instantiate()
        detailViewController.feed = feed
        return detailViewController
    }
}

extension FeedDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feed.styles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedStyleCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedStyleCollectionViewCell
        cell.configure(feed.styles[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        return layout.estimatedItemSize
    }
}
