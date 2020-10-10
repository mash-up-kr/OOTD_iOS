//
//  HomeViewController.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit
import RxRelay

// TODO: 공통으로 쓸 수 있는 ViewController 만들기
class HomeViewController: UIViewController, StoryboardView {
    @IBOutlet weak var headerWrapper: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nowDateLabel: UILabel!
    @IBOutlet weak var nowTemperatureLabel: UILabel!
    @IBOutlet weak var lowestTemperatureLabel: UILabel!
    @IBOutlet weak var highestTemperatureLabel: UILabel!
    @IBOutlet weak var averageTemperatureLabel: UILabel!
    @IBOutlet weak var nowWeatherImageView: UIImageView!
    @IBOutlet weak var nowWeatherLabel: UILabel!
    @IBOutlet weak var nowWeatherAdditionalInfoImageView: UIImageView!
    @IBOutlet weak var nowWeatherAdditionalInfoLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var headerAddButton: UIButton!
    @IBOutlet weak var feedContainerView: UIView!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var feedViewHeightConstraint: NSLayoutConstraint!
    private var didLayoutSubviewsInitially = false

    @IBOutlet weak var weatherSummaryView: UIView!
    @IBOutlet weak var summaryIamgeView: UIImageView!
    @IBOutlet weak var summaryAverageLabel: UILabel!
    @IBOutlet weak var summaryhighestTemperatureLabel: UILabel!
    @IBOutlet weak var summaryLowestTemperatureLabel: UILabel!
    @IBOutlet weak var homeMainImageView: UIImageView!

    typealias Reactor = HomeReactor

    var disposeBag: DisposeBag = DisposeBag()
    var feedViewControllerRef: FeedViewController?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.reactor = HomeReactor()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.requestWeather)
    }

    @IBAction func didTapMainCenterButton(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
}

extension HomeViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !didLayoutSubviewsInitially {
            feedViewHeightConstraint.constant = height.default
            didLayoutSubviewsInitially.toggle()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFeed" {
            let feedViewController = segue.destination as! FeedViewController
            feedViewController.delegate = self
            feedViewControllerRef = feedViewController
        }
    }

    func bind(reactor: HomeReactor) {
        reactor.state
            .map { $0.styleViewController }
            .subscribe(onNext: { [weak self] styleViewController in
                guard let self = self,
                    let styleViewController = styleViewController else { return }
                self.present(styleViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        reactor.state.map({ $0.isFailToNetwork })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.failToNetworkUI($0)
            })
            .disposed(by: disposeBag)

        reactor.state.compactMap({ $0.weatherData })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.weatherDataUI($0)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func showUploadFeedViewController(image: UIImage) {
        guard let naviController = UploadFeedViewController.newViewController(image: image) as? UINavigationController,
            let feedViewController = naviController.viewControllers.first as? UploadFeedViewController else {
            return
        }
        feedViewController.delegate = self
        present(naviController, animated: true)
    }

    private func failToNetworkUI(_ isFail: Bool) {
        print("fail \(isFail)")
    }

    private func weatherDataUI(_ weatherData: WeatherData) {
        nowTemperatureLabel.text = String(weatherData.temp) + "°"
        lowestTemperatureLabel.text = String(weatherData.minTemp) + "°"
        highestTemperatureLabel.text = String(weatherData.maxTemp) + "°"
        averageTemperatureLabel.text = "체감온도 " + String(weatherData.windChillTemp) + "°"
        nowWeatherAdditionalInfoLabel.text = "강수량 " + weatherData.precipitation + " mm"

        homeMainImageView.image = weatherData.weather.homeImage

        let nowDate = Date()

        nowDate.test()
        let month = Calendar.current.component(.month, from: nowDate)
        let day = Calendar.current.component(.day, from: nowDate)
        let hour = Calendar.current.component(.hour, from: nowDate)
        let minutes = Calendar.current.component(.minute, from: nowDate)

        nowDateLabel.text = "20년 \(month)월 \(day)일 " + nowDate.koreaWeekDay()
        updatedDateLabel.text = "업데이트 \(month)/\(day) \(hour):\(minutes)"
    }
}

extension HomeViewController: FeedPanGestureDelegate {
    var height: (default: CGFloat, expanded: CGFloat) {
        let min = view.bounds.height - view.safeAreaInsets.top - headerWrapper.bounds.height
        let max = view.bounds.height - view.safeAreaInsets.top
        return (min, max)
    }

    func didPanBegin(needsExpanded: Bool) {
        feedViewHeightConstraint.constant = needsExpanded ? height.expanded : height.default
        feedContainerView.shadowOpacity = needsExpanded ? 0 : 0.12
        feedView.cornerRadius = needsExpanded ? 0 : 12
//        weatherSummaryView.alpha = needsExpanded ? 1 : 0
//        homeMainImageView.alpha = needsExpanded ? 0 : 1
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: RefreshMainFeedDelegate {
    func refresh() {
        feedViewControllerRef?.requestFeed()
    }
}
