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

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers?[0].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icMenuFeedNormal"), selectedImage: UIImage(named: "icMenuFeedActive"))
        viewControllers?[1].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icMenuPlusNormal"), selectedImage: UIImage(named: "icMenuPlusActive"))
        viewControllers?[2].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icMenuMyNormal"), selectedImage: UIImage(named: "icMenuMyActive"))
    }
}
