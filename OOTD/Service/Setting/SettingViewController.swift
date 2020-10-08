//
//  SettingViewController.swift
//  OOTD
//
//  Created by Hochan Lee on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa

final class SettingViewController: UIViewController, StoryboardBuildable, StoryboardView {
    static func newViewController() -> UIViewController {
        let settingViewController = SettingViewController.instantiate()
        let reactor = SettingReactor()
        settingViewController.reactor = reactor

        return UINavigationController(rootViewController: settingViewController)
    }

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView!

    private var userName = OOTD.shared.user.name
    private var styles = OOTD.shared.styles

    private var selectedStyles: [Style] {
        collectionView.indexPathsForSelectedItems?.map { styles[$0.item] } ?? []
    }

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true

        let selectedStyles = styles.enumerated().compactMap { OOTD.shared.user.preference.styles.contains($0.element) ? $0 : nil }
        selectedStyles.forEach { collectionView.selectItem(at: IndexPath(item: $0.offset, section: .zero), animated: false, scrollPosition: .top) }
    }
}

extension SettingViewController {
    func bind(reactor: SettingReactor) {
    }
}

extension SettingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        reactor?.action.onNext(.setSelectedStyles(selectedStyles))
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.setSelectedStyles(selectedStyles))
    }
}
