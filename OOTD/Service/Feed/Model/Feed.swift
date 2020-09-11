//
//  FeedContent.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

struct FeedData: Decodable {
    let posts: [Feed]
    let hasNext: Bool
}

struct Feed: Decodable {
    let id: Int
    let nickname: String
    let photoUrl: URL?
    let message: String
    let weather: String
    let temperature: Int
    let date: String
    let styleIds: [Int]

    var styles: [Style] {
        styleIds.compactMap { OOTD.shared.styles.first(id: $0) }
    }
}

extension Feed: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
