//
//  UIViewController+Storyboard.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/24.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiate<Class: UIViewController>(storyboardName: String, withIdentifier identifier: String? = nil) -> Class {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        guard let identifier = identifier else {
            return storyboard.instantiateInitialViewController() as! Class
        }
        return storyboard.instantiateViewController(identifier: identifier) as! Class
    }
}
