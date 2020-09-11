//
//  UIApplication+Extension.swift
//  OOTD
//
//  Created by 이호찬 on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

extension UIApplication {
    static var targetViewController: UIViewController? {
        var targetViewController = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
        while targetViewController?.presentedViewController != nil {
            targetViewController = targetViewController?.presentedViewController
        }
        return targetViewController
    }

    static func changeRoot(viewController: UIViewController) {
        guard let window = Self.targetViewController?.view?.window else { return }
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
    }
}
