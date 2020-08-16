//
//  FeedViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/24.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

protocol FeedPanGestureDelegate: AnyObject {
    var height: (default: CGFloat, expanded: CGFloat) { get }
    func didPanBegin(needsExpanded: Bool)
}

class FeedViewController: UIViewController, StoryboardBuildable {
    @IBOutlet weak var filterCollectionView: FeedFilterCollectionView!
    @IBOutlet weak var contentCollectionView: FeedContentCollectionView!

    weak var delegate: FeedPanGestureDelegate!

    private let filters = FeedFilter.samples
    private let contents = FeedContent.samples

    private var isExpanded: Bool = false {
        didSet { contentCollectionView.isScrollEnabled = isExpanded }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func actionSelectFilter(_ sender: Any) {
        present(TagViewController.instantiate(userName: "포니"), animated: true, completion: nil)
    }

    @IBAction func actionPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            delegate.didPanBegin(needsExpanded: !isExpanded)
            isExpanded.toggle()
        default:
            break
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isExpanded else { return }
        if scrollView == contentCollectionView, contentCollectionView.contentOffset.y < 0 {
            delegate.didPanBegin(needsExpanded: false)
            isExpanded.toggle()
        }
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView is FeedFilterCollectionView {
            return filters.count
        }

        if collectionView is FeedContentCollectionView {
            return contents.count
        }

        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is FeedFilterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedFilterCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedFilterCollectionViewCell
            cell.configure(filters[indexPath.item])
            return cell
        }

        if collectionView is FeedContentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedContentCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedContentCollectionViewCell
            cell.configure(contents[indexPath.item])
            return cell
        }

        return collectionView.dequeueReusableCell(withReuseIdentifier: "NONE", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is FeedContentCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let width = (collectionView.bounds.width - layout.minimumInteritemSpacing) / 2
            return CGSize(width: width, height: width)
        }

        return .zero
    }
}
