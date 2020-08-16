//
//  Response+Extension.swift
//  OOTD
//
//  Created by 이호찬 on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import Moya

extension Response {
    func mapData<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = "data", using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) throws -> D {
        do {
            return try self.map(D.self, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
        } catch let error {
            throw MoyaError.objectMapping(error, self)
        }
    }
}
