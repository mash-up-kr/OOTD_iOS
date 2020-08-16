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
}

extension API: TargetType {
    var path: String {
        switch self {
        case .getStyles:
            return "api/styles"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStyles:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getStyles:
            return .requestPlain
        }
    }
}
