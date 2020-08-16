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
    @IBOutlet weak var tagCollectionView: FeedTagCollectionView!
    @IBOutlet weak var collectionView: FeedCollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!

    weak var delegate: FeedPanGestureDelegate!

    private let tags = Tag.samples
    private let feeds = Feed.samples
    private var disposeBag = DisposeBag()
    private var isExpanded: Bool = false {
        didSet { collectionView.isScrollEnabled = isExpanded }
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
        if scrollView == collectionView, collectionView.contentOffset.y < 0 {
            delegate.didPanBegin(needsExpanded: false)
            isExpanded.toggle()
        }
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView is FeedTagCollectionView {
            return tags.count
        }
        if collectionView is FeedCollectionView {
            return feeds.count
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is FeedTagCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTagCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedTagCollectionViewCell
            cell.configure(tags[indexPath.item])
            return cell
        }
        if collectionView is FeedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedCollectionViewCell
            cell.configure(feeds[indexPath.item])
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "NONE", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is FeedCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let width = (collectionView.bounds.width - layout.minimumLineSpacing) / 2
            return CGSize(width: width, height: width)
        }
        return .zero
    }
}
