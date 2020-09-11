//
//  Style.swift
//  OOTD
//
//  Created by pony.tail on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import RxSwift

struct Style: Decodable {
    let id: Int
    let name: String
}

extension Style: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Style {
    static let samples = [Style(id: 1, name: "힙스터"), Style(id: 2, name: "보헤미안"), Style(id: 3, name: "차이나타운")]

    static func initialize() {
        APIRequest.getStyles()
            .asObservable()
            .mapData([Style].self)
            .subscribe(onNext: { OOTD.shared.styles = $0 })
            .disposed(by: OOTD.shared.disposeBag)
    }
}

extension Array where Element == Style {
    func first(id: Int) -> Style? {
        for style in self {
            if style.id == id { return style }
        }
        return nil
    }
}
