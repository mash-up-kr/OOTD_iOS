//
//  APIRequest.swift
//  OOTD
//
//  Created by 이호찬 on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Moya
import RxMoya

final class APIRequest {
    private init() { }

    private static let provider = MoyaProvider<API>(endpointClosure: endpointClosure)

    private static let endpointClosure = { (target: API) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint
    }
}

extension APIRequest {
    static func getStyles() -> Single<Response> {
        provider.rx.request(.getStyles)
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
    }

    static func getFeed(parameters: [String: Any]) -> Single<Response> {
        provider.rx.request(.feed(parameters: parameters))
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
    }

    static func checkAuthToken() -> Single<Response> {
        provider.rx.request(.checkAuthToken)
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
    }

    static func signUp(uId: String, authType: String, nickname: String, styleIds: [Int]) -> Single<Response> {
        provider.rx.request(.signUp(uId: uId, authType: authType, nickname: nickname, styleIds: styleIds))
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
      }
}
