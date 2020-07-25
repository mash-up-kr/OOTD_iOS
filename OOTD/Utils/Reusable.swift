//
//  Reusable.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/24.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension UITableViewCell: Reusable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
