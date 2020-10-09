//
//  FeedDetailViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/09/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit

class FeedDetailViewController: UIViewController, StoryboardBuildable, StoryboardView {
    typealias Reactor = FeedDetailReactor

    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!

    private var feed: Feed!
    private var comments = [FeedComment]() {
        didSet {
            let title = comments.isEmpty ? "댓글달기" : "댓글보기 +\(comments.count)"
            commentsButton.setTitle(title, for: .normal)
        }
    }

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = FeedDetailReactor(feed: feed)

        userNicknameLabel.text = feed.nickname
        photoImageView.kf.setImage(with: feed.photoUrl)
        temperatureLabel.text = "\(feed.temperature)°"
        bodyLabel.text = feed.message

        commentsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let commentViewController = FeedCommentViewController.instantiate(comments: self.comments, for: self.feed)
                self.navigationController?.pushViewController(commentViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.requestComments(feed: feed))
    }

    func bind(reactor: FeedDetailReactor) {
        reactor.state
            .compactMap { $0.comments }
            .subscribe(onNext: {[weak self] comments in
                self?.comments = comments
            })
            .disposed(by: disposeBag)
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
