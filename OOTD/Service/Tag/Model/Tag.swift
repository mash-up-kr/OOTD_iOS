//
//  Tag.swift
//  OOTD
//
//  Created by pony.tail on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

struct Tag: Decodable {
    let id: Int
    let name: String
}

extension Tag: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Tag {
    static let samples = [Tag(id: 1, name: "힙스터"), Tag(id: 2, name: "보헤미안"), Tag(id: 3, name: "차이나타운")]
}
