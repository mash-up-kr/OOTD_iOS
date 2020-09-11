//
//  UserInfo.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

struct UserInfo: Decodable {
    let nickname: String
    let styleIds: [Int]
}
