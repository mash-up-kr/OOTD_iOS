//
//  FeedViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/24.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol FeedPanGestureDelegate: AnyObject {
    var height: (default: CGFloat, expanded: CGFloat) { get }

    func didPanBegin(needsExpanded: Bool)
}

class FeedViewController: UIViewController, StoryboardBuildable {
    @IBOutlet weak var filterCollectionView: FeedFilterCollectionView!
    @IBOutlet weak var contentCollectionView: FeedContentCollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!

    weak var delegate: FeedPanGestureDelegate!

    private let tags = Tag.samples
    private let feeds = Feed.samples
    private var disposeBag = DisposeBag()
    private var isExpanded: Bool = false {
        didSet { contentCollectionView.isScrollEnabled = isExpanded }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.present(TagViewController.instantiate(userName: "포니"), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        panGestureRecognizer.rx.event
            .subscribe(onNext: { [weak self] gestureRecognizer in
                guard let self = self else { return }
                if gestureRecognizer.state == .began {
                    self.delegate.didPanBegin(needsExpanded: !self.isExpanded)
                    self.isExpanded.toggle()
                }
            })
            .disposed(by: disposeBag)
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
            return tags.count
        }
        if collectionView is FeedContentCollectionView {
            return feeds.count
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is FeedFilterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedFilterCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedFilterCollectionViewCell
            cell.configure(tags[indexPath.item])
            return cell
        }
        if collectionView is FeedContentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedContentCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedContentCollectionViewCell
            cell.configure(feeds[indexPath.item])
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "NONE", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is FeedContentCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let width = (collectionView.bounds.width - layout.minimumLineSpacing) / 2
            return CGSize(width: width, height: width)
        }
        return .zero
    }
}
