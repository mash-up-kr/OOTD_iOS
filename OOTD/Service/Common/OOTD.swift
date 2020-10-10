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
        user = User()
        styles = []
    }

    var styles: [Style]
    var user: User
    var stylesPublishSubject = PublishSubject<[Style]>()

    static func initialize() {
        Style.initialize()
    }
}
