//
//  FilterViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/04.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit

class FilterViewController: UIViewController, StoryboardBuildable, StoryboardView {
    typealias Reactor = FilterReactor

    enum Tab {
        case style
        case weather
    }

    @IBOutlet var tabButtons: [UIButton]!
    @IBOutlet var tabContainerViews: [UIView]!
    @IBOutlet weak var styleTabButton: UIButton!
    @IBOutlet weak var styleContainerView: UIView!
    @IBOutlet weak var weatherTabButton: UIButton!
    @IBOutlet weak var weatherContainerView: UIView!

    var disposeBag = DisposeBag()

    private var currentTab: Tab = .style

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherViewController = segue.destination as? SelectTemperatureViewController {
            weatherViewController.delegate = self
        }
        if let styleViewController = segue.destination as? StyleViewController {
            styleViewController.hideCompleteButton()
            styleViewController.reactor = StyleReactor()
            styleViewController.reactor?.stylesPublishSubject
                .subscribe(onNext: { [weak self] styles in
                    self?.reactor?.action.onNext(.didChangeStyles(styles))
                })
                .disposed(by: disposeBag)
        }
    }

    @IBAction func actionSelectStyleFilter(_ sender: Any) {
        if currentTab == .style { return }
        selectTab(tab: .style)
    }

    @IBAction func actionSelectWeatherFilter(_ sender: Any) {
        if currentTab == .weather { return }
        selectTab(tab: .weather)
    }

    @IBAction func actionComplete(_ sender: Any) {
        reactor?.action.onNext(.complete)
    }

    private func selectTab(tab: Tab) {
        tabButtons.forEach { $0.isSelected = false }
        tabContainerViews.forEach { $0.isHidden = true }
        currentTab = tab

        switch tab {
        case .style:
            styleTabButton.isSelected = true
            styleContainerView.isHidden = false
        case .weather:
            weatherTabButton.isSelected = true
            weatherContainerView.isHidden = false
        }
    }

    func bind(reactor: FilterReactor) {
        reactor.state
            .map { $0.complete }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] complete in
                guard complete else { return }
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension FilterViewController: SelectTemparatureDelegate {
    func didChangeTemparature(_ temp: Int) {
        reactor?.action.onNext(.didChangeTemperature(temp))
    }

    func didChangeWeather(_ weather: FeedWeatherType) {
        reactor?.action.onNext(.didChangeWeather(weather))
    }
}
