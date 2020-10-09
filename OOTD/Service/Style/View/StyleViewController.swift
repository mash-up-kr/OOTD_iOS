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

    @IBOutlet weak var completeButton: UIButton!

    private var userName = OOTD.shared.user.name
    private var styles = OOTD.shared.styles

    var disposeBag = DisposeBag()
    weak var delegate: SelectedStyleDelegate?
    var needHideCompleteButton: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true

        let selectedStyles = styles.enumerated().compactMap { OOTD.shared.user.preference.styles.contains($0.element) ? $0 : nil }
//        reactor?.stylesPublishSubject.onNext(selectedStyles.map { $0.element })
        selectedStyles.forEach { collectionView.selectItem(at: IndexPath(item: $0.offset, section: .zero), animated: false, scrollPosition: .top) }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if needHideCompleteButton {
            completeButton.isHidden = true
        }
    }

    static func instantiate(userName: String) -> Self {
        let styleViewController = instantiate()
        styleViewController.userName = userName
        return styleViewController
    }

    @IBAction func actionComplete(_ sender: Any) {
        if reactor?.currentState.authType != nil {
            let ids = selectedStyles.map { $0.id }
            reactor?.action.onNext(.requestSignUp(ids))
        } else {
            reactor?.stylesPublishSubject.onNext(selectedStyles)
            dismiss(animated: true, completion: nil)
        }
    }

    private var selectedStyles: [Style] {
        collectionView.indexPathsForSelectedItems?.map { styles[$0.item] } ?? []
    }

    func hideCompleteButton() {
        needHideCompleteButton = true
    }
}

extension StyleViewController {
    func bind(reactor: StyleReactor) {
        reactor.state.compactMap { $0.userInfo }
            .subscribe(onNext: { _ in
                UIApplication.changeRoot(viewController: MainTabBarViewController.newViewController())
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.stylesPublishSubject.onNext(selectedStyles)
        delegate?.selectedStyle(selectedStyles.map { $0.id })
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        reactor?.stylesPublishSubject.onNext(selectedStyles)
        delegate?.selectedStyle(selectedStyles.map { $0.id })
    }
}

protocol SelectedStyleDelegate: AnyObject {
    func selectedStyle(_ styleIds: [Int])
}
