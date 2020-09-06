//
//  TagViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class TagViewController: UIViewController, StoryboardBuildable, StoryboardView {
    @IBOutlet weak var collectionView: UICollectionView!

    private var userName = "포니"
    private var tags = [Tag]()

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true

        reactor?.action.onNext(.requestTags)
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

extension TagViewController {
    func bind(reactor: TagReactor) {
        reactor.state.map { $0.tags }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] tags in
                guard let self = self else { return }
                self.tags = tags
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension TagViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
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
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 200 / 667)
    }
}
