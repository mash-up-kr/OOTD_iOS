//
//  Revision.swift
//  OOTD
//
//  Created by 이호찬 on 2020/07/26.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

struct Revision<T> {
    private var version: UInt = 0
    
    var value: T {
        didSet { version += 1 }
    }
    
    init(value: T) {
        self.value = value
    }
}

extension Revision: Equatable {
    static func == (lhs: Revision<T>, rhs: Revision<T>) -> Bool {
        lhs.version == rhs.version
    }
}
