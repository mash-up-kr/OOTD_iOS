//
//  UploadFeedInfoViewController.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/10.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class UploadFeedInfoViewController: UIViewController, StoryboardBuildable, StoryboardView {
    @IBOutlet weak var dateViewTargetButton: UIButton!
    @IBOutlet weak var styleViewTargetButton: UIButton!
    @IBOutlet weak var loactionViewTargetButton: UIButton!
    @IBOutlet weak var weatherViewTargetButton: UIButton!

    @IBOutlet weak var selectDateCalendarView: UIView!
    @IBOutlet weak var selectStyleView: UIView!
    @IBOutlet weak var selectLocationView: UIView!
    @IBOutlet weak var selectWeatherView: UIView!

    var weatherInfoViewController: SelectTemperatureViewController?
    weak var delegate: RefreshMainFeedDelegate?

    var disposeBag = DisposeBag()

    static func newViewController(_ image: UIImage?, _ content: String) -> UIViewController {
        let viewController = UploadFeedInfoViewController.instantiate()
        viewController.reactor = UploadFeedInfoReactor(image, content)
        return viewController
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectTemperatureViewController = segue.destination as? SelectTemperatureViewController {
            selectTemperatureViewController.delegate = self
        }

        if let styleViewController = segue.destination as? StyleViewController {
            styleViewController.hideCompleteButton()
            styleViewController.delegate = self
        }
    }

    @IBAction func didTapBeforeButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapUploadButtonAction(_ sender: Any) {
        reactor?.action.on(.next(.didTapUploadButton))
    }

    @IBAction func didTapDateTargetButtonAction(_ sender: Any) {
        reactor?.action.on(.next(.didTapInfoTargetButton(.date)))
    }
    @IBAction func didTapStyleTargetButtonAction(_ sender: Any) {
        reactor?.action.on(.next(.didTapInfoTargetButton(.style)))
    }
    @IBAction func didTapStyleLocationButtonAction(_ sender: Any) {
        reactor?.action.on(.next(.didTapInfoTargetButton(.location)))
    }
    @IBAction func didTapStyleWeatherButtonAction(_ sender: Any) {
        reactor?.action.on(.next(.didTapInfoTargetButton(.weather)))
    }

    private func uploadDoneAlert() {
        let alert = UIAlertController(title: "업로드 완료", message: "스타일 업로드가 완료 되었습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: false)
            self.tabBarController?.selectedIndex = 0
        })
    }
}

extension UploadFeedInfoViewController {
    func bind(reactor: UploadFeedInfoReactor) {
        reactor.state
            .map { $0.showViewTarget }
            .subscribe(onNext: { [weak self] viewTarget in
                self?.hideAllInfoContentView()
                self?.deselectAllViewTargetButton()
                switch viewTarget {
                case .date:
                    self?.dateViewTargetButton.isSelected = true
                    self?.selectDateCalendarView.isHidden = false
                case .style:
                    self?.styleViewTargetButton.isSelected = true
                    self?.selectStyleView.isHidden = false
                case .location:
//                    self?.loactionViewTargetButton.isSelected = true
                    self?.selectLocationView.isHidden = false
                case .weather:
                    self?.weatherViewTargetButton.isSelected = true
                    self?.selectWeatherView.isHidden = false
                }
            })
        .disposed(by: disposeBag)

        reactor.state
            .map { $0.uploadIsDone }
            .filter({ $0 })
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.refresh()
                self?.uploadDoneAlert()
            })
        .disposed(by: disposeBag)
    }

    private func hideAllInfoContentView() {
        selectDateCalendarView.isHidden = true
        selectStyleView.isHidden = true
        selectLocationView.isHidden = true
        selectWeatherView.isHidden = true
    }

    private func deselectAllViewTargetButton() {
        dateViewTargetButton.isSelected = false
        styleViewTargetButton.isSelected = false
//        loactionViewTargetButton.isSelected = false
        weatherViewTargetButton.isSelected = false
    }
}

extension UploadFeedInfoViewController: SelectTemparatureDelegate {
    func didChangeTemparature(_ temp: Int) {
        reactor?.action.onNext(.didChangeTemparature(temp))
    }

    func didChangeWeather(_ weather: FeedWeatherType) {
        reactor?.action.onNext(.didChangeWeatherInfo(weather))
    }
}

extension UploadFeedInfoViewController: SelectedStyleDelegate {
    func selectedStyle(_ styleIds: [Int]) {
        reactor?.action.onNext(.didChangeStyles(styleIds))
    }
}
