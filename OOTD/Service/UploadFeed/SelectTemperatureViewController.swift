//
//  SelectTemperatureViewController.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class SelectTemperatureViewController: UIViewController, StoryboardBuildable, StoryboardView {
    var disposeBag = DisposeBag()

    static func newViewController() -> UIViewController {
        UIViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SelectTemperatureViewController {
    func bind(reactor: SelectTemperatureReactor) {
    }
}
