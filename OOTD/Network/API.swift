//
//  API.swift
//  OOTD
//
//  Created by 이호찬 on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import Moya

enum API {
    case getStyles
    case signIn
    case feed
}

extension API: TargetType {
    var path: String {
        switch self {
        case .getStyles:
            return "api/styles"
        case .signIn:
            return "api/users/sign-in"
        case .feed:
            return "api/posts"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStyles:
            return .get
        case .signIn:
            return .post
        case .feed:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getStyles:
            return .requestPlain
        case .signIn:
            return .requestPlain
        case .feed:
            return .requestParameters(parameters:
                                        [
                                            "styleIds": "1,2",
                                            "weather": "CLEAR",
                                            "minTemp": 21,
                                            "maxTemp": 23,
                                            "lastPostId": 10
                                        ],
                                      encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Authorization": OOTD.shared.user.token]
    }
}
