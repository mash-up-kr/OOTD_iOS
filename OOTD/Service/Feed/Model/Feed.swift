//
//  FeedContent.swift
//  OOTD
//
//  Created by pony.tail on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

struct Feed: Decodable {
    let id: Int
    let photoUrl: URL?
    let message: String
    let weather: String
    let temperature: String
    let date: String
}

extension Feed: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
