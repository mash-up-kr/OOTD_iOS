//
//  UINavigationController+Extension.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/10.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

extension UINavigationController {
    static func withNavigationBarHidden(_ rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
}
