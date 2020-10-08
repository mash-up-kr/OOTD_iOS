//
//  SplashViewController.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/06.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit

final class SplashViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.reactor = SplashReactor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.reactor = SplashReactor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIApplication.changeRoot(viewController: SettingViewController.newViewController())
        if AccountManager.authToken != nil {
            reactor?.action.onNext(.checkAuthToken)
        } else {
            UIApplication.changeRoot(viewController: LoginViewController.newViewController())
        }
    }
}

extension SplashViewController {
    func bind(reactor: SplashReactor) {
        reactor.state.compactMap { $0.isValid }
            .distinctUntilChanged()
            .subscribe(onNext: {
                $0 ? UIApplication.changeRoot(viewController: MainTabBarViewController.newViewController())
                    : UIApplication.changeRoot(viewController: LoginViewController.newViewController())
            })
            .disposed(by: disposeBag)
    }
}
