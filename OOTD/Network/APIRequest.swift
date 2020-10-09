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

    static func getComments(feed: Feed) -> Single<Response> {
        provider.rx.request(.comments(feed: feed))
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
    }

    static func checkAuthToken() -> Single<Response> {
        provider.rx.request(.checkAuthToken)
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
    }

    static func signIn(uId: String, authType: String) -> Single<Response> {
        provider.rx.request(.signIn(uId: uId, authType: authType))
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
      }

    static func signUp(uId: String, authType: String, nickname: String, styleIds: [Int]) -> Single<Response> {
        provider.rx.request(.signUp(uId: uId, authType: authType, nickname: nickname, styleIds: styleIds))
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
      }

    static func uploadFeed(feedInfo: FeedBaseBody, weathrerInfo: FeedWeatherInfoBody, styleIds: [Int]) -> Single<Response> {
        var formdata: [Moya.MultipartFormData] = []
        if let imageFormData = feedInfo.imageMultipartFormData, let messageFormData = feedInfo.contentMultipartFormData {
            formdata.append(imageFormData)
            formdata.append(messageFormData)
        }
        if let dateString = Date().patternizedString("yyyy-MM-dd"), let dateFormData = dateString.multipartFormData("date") {
            formdata.append(dateFormData)
        }
        if let weatherData = weathrerInfo.weatherMultipartFormData {
            formdata.append(weatherData)
        }
        if let temparatureData = weathrerInfo.temparatureFormData {
            formdata.append(temparatureData)
        }
        if !styleIds.isEmpty {
            var styleString: String {
                var resultString = ""
                for (index, styleId) in styleIds.enumerated() {
                    resultString += String(styleId)
                    if index != styleIds.count - 1 {
                        resultString += ","
                    }
                }
                return resultString
            }
            if let styleFormData = styleString.multipartFormData("styleIds") {
                formdata.append(styleFormData)
            }
        }

        return provider.rx.request(.uploadFeed(data: formdata))
            .filterTimeOutError()
            .filterSuccessfulStatusCodes()
    }
}
