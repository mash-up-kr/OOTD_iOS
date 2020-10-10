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
    @IBOutlet weak var headerSelectedDateLabel: UILabel!
    @IBOutlet weak var calendarMonthLabel: UILabel!
    @IBOutlet weak var dateCollectionView: UICollectionView!

    var disposeBag = DisposeBag()
    lazy var collectionViewItemSpacing: CGFloat = {
        ( dateCollectionView.bounds.width - 210 ) / 7
    }()

    var dayOffset: Int = 0
    var numberOfCalendarCell: Int = 0

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        reactor = SelectDateCalendarReactor()
    }

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

    @IBAction func didTapPreviosMonth(_ sender: Any) {
        reactor?.action.onNext(.changePreviousMonth)
    }

    @IBAction func didTapNextMonth(_ sender: Any) {
        reactor?.action.onNext(.changeNextMonth)
    }

    private func setSelectedDateUI(_ selectedDate: Date) {
        let year = Calendar.current.component(.year, from: selectedDate) % 100
        let month = Calendar.current.component(.month, from: selectedDate)
        let day = Calendar.current.component(.day, from: selectedDate)
        headerSelectedDateLabel.text = "\(year)년 \(month)월 \(day)일"
    }

    private func setCalendarMonthLabel(_ calendarDate: Date) {
        let year = Calendar.current.component(.year, from: calendarDate)
        let month = Calendar.current.component(.month, from: calendarDate)
        calendarMonthLabel.text = "\(year)년 \(month)월"
    }
}

extension SelectDateCalendarViewController {
    func bind(reactor: SelectDateCalendarReactor) {
        reactor.state
            .map({ $0.dateForCalendarUI })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] date in
                self?.dayOffset = date.firstDateWeekDay()
                self?.numberOfCalendarCell = date.getDaysInMonth()
                self?.dateCollectionView.reloadData()
                self?.setCalendarMonthLabel(date)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedDate }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] selectedDate in
                self?.setSelectedDateUI(selectedDate)
            })
            .disposed(by: disposeBag)
    }
}

extension SelectDateCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dayOffset + numberOfCalendarCell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDateCollectionViewCell", for: indexPath) as? SelectDateCollectionViewCell else {
            return UICollectionViewCell()
        }

        let dateDay = indexPath.row - dayOffset + 1

        if dateDay >= 1 {
            cell.setDate(String(dateDay))
        } else {
            cell.setDate("")
        }

        return cell
    }
}

extension SelectDateCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: floor(dateCollectionView.bounds.width / 7.0), height: 30.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dateDay = indexPath.row - dayOffset + 1
        if dateDay >= 1 {
            reactor?.action.onNext(.selectDay(dateDay))
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
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
