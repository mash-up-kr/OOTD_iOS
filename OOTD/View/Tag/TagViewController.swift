//
//  TagViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

typealias Tag = FeedFilter
class TagViewController: UIViewController, StoryboardBuildable {
    @IBOutlet weak var collectionView: UICollectionView!

    private var userName = "포니"
    private let tags = Tag.heavySamples

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
    }

    static func instantiate(userName: String) -> Self {
        let tagViewController = instantiate()
        tagViewController.userName = userName
        return tagViewController
    }

    @IBAction func actionComplete(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension TagViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reusableIdentifier, for: indexPath) as! TagCollectionViewCell
        cell.configure(tags[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TagCollectionHeaderView.reusableIdentifier, for: indexPath) as! TagCollectionHeaderView
        headerView.configure(userName: userName)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 200 / 667)
    }
}
