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
    case signIn(uId: String, authType: String)
    case feed(parameters: [String: Any])
    case checkAuthToken
    case signUp(uId: String, authType: String, nickname: String, styleIds: [Int])
    case uploadFeed(data: [MultipartFormData])
    case weather
}

extension API: TargetType {
    var path: String {
        switch self {
        case .getStyles:
            return "api/styles"
        case .signIn:
            return "api/users/sign-in"
        case .signUp:
            return "api/users/sign-up"
        case .feed:
            return "api/posts"
        case .checkAuthToken:
            return "api/users/access-token-info"
        case .uploadFeed:
            return "api/posts"
        case .weather:
            return "api/weather"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStyles:
            return .get
        case .signIn:
            return .post
        case .signUp:
            return .post
        case .feed:
            return .get
        case .checkAuthToken:
            return .get
        case .uploadFeed:
            return .post
        case .weather:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getStyles:
            return .requestPlain
        case let .signIn(uId, authType):
            let parameter: [String: Any] = [
                "uid": uId,
                "authType": authType
            ]

            return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
        case .feed(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .checkAuthToken:
            return .requestPlain
        case let .signUp(uId, authType, nickname, styleIds):
            let parameter: [String: Any] = [
                "uid": uId,
                "authType": authType,
                "nickname": nickname,
                "styleIds": styleIds
            ]

            return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
        case .uploadFeed(let data):
            return .uploadMultipart(data)
        case .weather:
            return .requestParameters(parameters: ["lat": "37.566535", "lon": "126.977969"], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Authorization": AccountManager.authToken ?? OOTD.shared.user.token]
    }
}
