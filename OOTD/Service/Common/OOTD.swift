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

    static func initialize() {
        Style.initialize()
    }

    struct User {
        // To. hochan 임시로 내 토큰 사용했음!
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6Mn0.FdCGmwbTqAohz4OWA1CKdtZxsNhE9RDTXgAfoTliR6A"
    }
}
