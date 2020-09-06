//
//  MainTabBarViewController.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, StoryboardBuildable {
    static func newViewController() -> UIViewController {
        let viewController = MainTabBarViewController.instantiate()

        return viewController
    }
}
