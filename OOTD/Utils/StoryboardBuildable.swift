//
//  StoryboardBuildable.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/24.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

protocol StoryboardBuildable: UIViewController {
    static var storyboardName: String { get }
}

extension StoryboardBuildable {
    static var storyboardName: String {
        return String(describing: self).replacingOccurrences(of: "ViewController", with: "")
    }
    
    static func instantiate() -> Self {
        return Self.instantiate(storyboardName: storyboardName)
    }
    
    static func instantiate(withIdentifier identifier: String) -> Self {
        return Self.instantiate(storyboardName: storyboardName, withIdentifier: identifier)
    }
}
