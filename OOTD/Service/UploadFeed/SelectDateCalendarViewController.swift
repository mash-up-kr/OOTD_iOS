//
//  SelectDateCalendarViewController.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class SelectDateCalendarViewController: UIViewController, StoryboardBuildable, StoryboardView {
    @IBOutlet weak var dateCollectionView: UICollectionView!

    var disposeBag = DisposeBag()
    lazy var collectionViewItemSpacing: CGFloat = {
        ( dateCollectionView.bounds.width - 210 ) / 7
    }()

    var testLength: Int = 0

    static func newViewController() -> UIViewController {
        let viewController = SelectDateCalendarViewController.instantiate()
        viewController.reactor = SelectDateCalendarReactor()
        viewController.modalPresentationStyle = .fullScreen

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateCollectionView.register(UINib(nibName: "SelectDateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectDateCollectionViewCell")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        testLength = 100
        dateCollectionView.reloadData()
    }
}

extension SelectDateCalendarViewController {
    func bind(reactor: SelectDateCalendarReactor) {
    }
}

extension SelectDateCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        testLength
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDateCollectionViewCell", for: indexPath) as? SelectDateCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setDate("1")

        return cell
    }
}

extension SelectDateCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: floor(dateCollectionView.bounds.width / 7.0), height: 30.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension SelectDateCalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 12.0, left: 0, bottom: 0, right: 0)
    }
}
