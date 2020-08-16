//
//  APITargetType.swift
//  OOTD
//
//  Created by 이호찬 on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import Moya

var baseURLStrng: String {
    "http://52.78.79.159:8080"
}

func getHeaders() -> [String: String] {
    let headers: [String: String] = [:]

    return headers
}

extension TargetType {
    var baseURL: URL {
        guard let url = URL(string: baseURLStrng) else { fatalError("baseURL could not be configured.") }

        return url
    }

    var headers: [String: String]? {
        getHeaders()
    }

    var sampleData: Data {
        Data(count: 0)
    }
}
