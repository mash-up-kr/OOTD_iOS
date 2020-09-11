//
//  StyleViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class StyleViewController: UIViewController, StoryboardBuildable, StoryboardView {
    @IBOutlet weak var collectionView: UICollectionView!

    private var userName = "포니"
    private var styles = [Style]()

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
    }

    static func instantiate(userName: String) -> Self {
        let styleViewController = instantiate()
        styleViewController.userName = userName
        return styleViewController
    }

    @IBAction func actionComplete(_ sender: Any) {
        let style = collectionView.indexPathsForSelectedItems?.map { styles[$0.item] } ?? []
        reactor?.stylesPublishSubject.onNext(style)
        dismiss(animated: true, completion: nil)
    }
}

extension StyleViewController {
    func bind(reactor: StyleReactor) {
        reactor.state.map { $0.styles }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] styles in
                guard let self = self else { return }
                self.styles = styles
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension StyleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        styles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleCollectionViewCell.reusableIdentifier, for: indexPath) as! StyleCollectionViewCell
        cell.configure(styles[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StyleCollectionHeaderView.reusableIdentifier, for: indexPath) as! StyleCollectionHeaderView
        headerView.configure(userName: userName)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 200 / 667)
    }
}