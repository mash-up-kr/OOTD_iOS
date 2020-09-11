//
//  OOTD.swift
//  OOTD
//
//  Created by pony.tail on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import RxSwift

class OOTD {
    static let shared = OOTD()
    var disposeBag = DisposeBag()

    private init() {
        styles = []
    }

    var styles: [Style]

    static func initialize() {
        Style.initialize()
    }
}
