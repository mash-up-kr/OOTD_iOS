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

    @IBOutlet weak var weathreImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureRangeLabel: UILabel!
    @IBOutlet weak var styleCollectionView: FeedStyleCollectionView!
    @IBOutlet weak var collectionView: FeedCollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!

    weak var delegate: FeedPanGestureDelegate!
    var disposeBag = DisposeBag()

    private var filterSubscription: Disposable?
    private var filter = Filter() {
        didSet {
            updateFilter()
            requestFeed()
        }
    }
    private var feed = [Feed]() {
        didSet { collectionView.reloadData() }
    }
    private var isExpanded: Bool = false {
        didSet { collectionView.isScrollEnabled = isExpanded }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = FeedReactor()

        reloadWeather()
        requestFeed()

        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let filterReactor = FilterReactor()
                self.filterSubscription = filterReactor.filterPublishSubject
                    .subscribe(onNext: { [weak self] filter in self?.filter = filter },
                               onCompleted: { [weak self] in self?.filterSubscription?.dispose() })

                let filterViewController = FilterViewController.instantiate()
                filterViewController.reactor = filterReactor
                self.present(filterViewController, animated: true)
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

    private func updateFilter() {
        let user = OOTD.shared.user
        user.preference.styles = filter.styles
        user.location.weather = filter.weather.weather
        user.preference.temperature.value = filter.weather.temparature
        user.preference.temperature.range = 3

        styleCollectionView.reloadData()
        reloadWeather()
    }

    private func reloadWeather() {
        let weathre = OOTD.shared.user.location.weather
        weathreImageView.image = UIImage(named: weathre.imageName)
        let temperature = OOTD.shared.user.preference.temperature
        temperatureLabel.text = "\(temperature.value)"
        temperatureRangeLabel.text = "\(temperature.min)° - \(temperature.max)°"
    }

    func requestFeed() {
        let user = OOTD.shared.user
        let parameters: [String: Any] =
            [
                "styleIds": user.preference.styles.map { String($0.id) }.joined(separator: ","),
                "weather": user.location.weather,
                "minTemp": user.preference.temperature.min,
                "maxTemp": user.preference.temperature.max
//                "lastPostId": 100
            ]
        reactor?.action.onNext(.requestFeed(parameters: parameters))
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
                self?.feed = feed
            })
            .disposed(by: disposeBag)
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView is FeedStyleCollectionView {
            return filter.styles.count
        }
        if collectionView is FeedCollectionView {
            return feed.count
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is FeedStyleCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedStyleCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedStyleCollectionViewCell
            cell.configure(filter.styles[indexPath.item])
            return cell
        }
        if collectionView is FeedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.reusableIdentifier, for: indexPath) as! FeedCollectionViewCell
            cell.configure(feed[indexPath.item])
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "NONE", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView is FeedCollectionView {
            let feedDetailViewController = FeedDetailViewController.instantiate(feed: feed[indexPath.item])
            let navigationController = UINavigationController(rootViewController: feedDetailViewController)
            present(navigationController, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is FeedCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let width = (collectionView.bounds.width - layout.minimumLineSpacing) / 2.0
            return CGSize(width: width, height: width)
        }
        if collectionView is FeedStyleCollectionView {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            return layout.estimatedItemSize
        }
        return .zero
    }
}

protocol RefreshMainFeedDelegate: AnyObject {
    func refresh()
}
