//
//  SplashViewController.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/06.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let authToken = AccountManager.authToken {
            // 우리서버 네트워킹 타고 성공하면 메인으로 바꿔주기
            changeRoot(viewController: MainTabBarViewController.newViewController())
        } else {
            // 임시로 메인탭으로 가도록 바꿔줌 auth 없으면 여기서 로그인으로
            changeRoot(viewController: MainTabBarViewController.newViewController())

//            changeRoot(viewController: LoginViewController.newViewController())
        }
    }
}

extension SplashViewController {
    private func changeRoot(viewController: UIViewController) {
        guard let window = view.window else { return }
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
    }
}
