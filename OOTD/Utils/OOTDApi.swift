//
//  OOTDApi.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

struct OOTDApi<T: Decodable>: Decodable {
    let code: Int
    let msg: String
    let data: T?
}
