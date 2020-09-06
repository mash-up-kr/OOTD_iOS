//
//  FeedViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/24.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

protocol FeedPanGestureDelegate: AnyObject {
    var height: (default: CGFloat, expanded: CGFloat) { get }

    func didPanBegin(needsExpanded: Bool)
}

class FeedViewController: UIViewController, StoryboardBuildable, StoryboardView {
    typealias Reactor = FeedReactor

    @IBOutlet weak var tagCollectionView: FeedTagCollectionView!
    @IBOutlet weak var collectionView: FeedCollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!

    weak var delegate: FeedPanGestureDelegate!
    var disposeBag = DisposeBag()

    private var tags = Tag.samples
    private var feed = [Feed]()
    private var isExpanded: Bool = false {
        didSet { collectionView.isScrollEnabled = isExpanded }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = FeedReactor()
        reactor?.action.onNext(.requestFeed)

        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let tagViewController = TagViewController.instantiate(userName: "포니")
                tagViewController.reactor = TagReactor()
                self.present(tagViewController, animated: true)
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

extension FeedViewController {
    func bind(reactor: FeedReactor) {
        reactor.state.map { $0.feed }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] feed in
                guard let self = self else { return }
                self.feed = feed
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView is FeedTagCollectionView {
            return tags.count
        }
        if collectionView is FeedCollectionView {
            return feed.count
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
            cell.configure(feed[indexPath.item])
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "NONE", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is FeedCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let width = (collectionView.bounds.width - layout.minimumLineSpacing) / 2.0
            return CGSize(width: width, height: width)
        }
        return .zero
    }
}
