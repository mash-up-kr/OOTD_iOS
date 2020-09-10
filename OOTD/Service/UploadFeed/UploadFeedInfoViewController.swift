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
    var disposeBag = DisposeBag()

    static func newViewController(_ image: UIImage?, _ content: String) -> UIViewController {
        let viewController = UploadFeedInfoViewController.instantiate()
        viewController.reactor = UploadFeedInfoReactor(image, content)
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapBeforeButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapUploadButtonAction(_ sender: Any) {
        print("upload")
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
}

extension UploadFeedInfoViewController {
    func bind(reactor: UploadFeedInfoReactor) {
        reactor.state
            .map { $0.showViewTarget }
            .subscribe(onNext: { [weak self] viewTarget in
                switch viewTarget {
                case .date:
                    print("date")
                case .style:
                    print("style")
                case .location:
                    print("location")
                case .weather:
                    print("weather")
                }
            })
        .disposed(by: disposeBag)
    }
}
