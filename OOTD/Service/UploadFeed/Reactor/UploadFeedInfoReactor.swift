//
//  UploadFeedInfoReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/10.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit
import Moya

final class UploadFeedInfoReactor: Reactor {
    enum ViewInfoTarget {
        case date
        case style
        case location
        case weather
    }

    enum UpdateBodyTaraget {
        case weather(FeedWeatherType)
        case temparature(Int)
    }

    enum Action {
        case didTapInfoTargetButton(ViewInfoTarget)
        case didTapUploadButton
        case didChangeWeatherInfo(FeedWeatherType)
        case didChangeTemparature(Int)
    }

    enum Mutation {
        case changeInfoView(ViewInfoTarget)
//        case requestUpload
        case changeBodyInfo
        case uploadIsDone
        case uploadIsFail
    }

    struct State {
        var showViewTarget: ViewInfoTarget = .weather

        var uploadIsDone: Bool = false
        var uploadFail: Bool = false
    }

    var initialState: State
    var feedBaseBody: FeedBaseBody
    var feedWeatherBody: FeedWeatherInfoBody = FeedWeatherInfoBody(weather: .CLEAR, temparature: 24)
    var styleIds: [Int] = []

    init(_ image: UIImage?, _ content: String) {
        self.feedBaseBody = FeedBaseBody(image: image, content: content)
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapInfoTargetButton(let target):
            return Observable.just(.changeInfoView(target))
        case .didTapUploadButton:
            return APIRequest
                .uploadFeed(feedInfo: feedBaseBody, weathrerInfo: feedWeatherBody, styleIds: styleIds)
                .asObservable()
                .map({ res in
                    if res.statusCode < 300 {
                        return Mutation.uploadIsDone
                    } else {
                        return Mutation.uploadIsFail
                    }
                })
        case .didChangeWeatherInfo(let weather):
            feedWeatherBody.changeWeather(weather)
            return Observable.just(.changeBodyInfo)
        case .didChangeTemparature(let temparature):
            feedWeatherBody.changeTemparature(temparature)
            return Observable.just(.changeBodyInfo)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.uploadFail = false

        switch mutation {
        case .changeInfoView(let viewTarget):
            newState.showViewTarget = viewTarget
        case .uploadIsDone:
            newState.uploadIsDone = true
        case .uploadIsFail:
            newState.uploadFail = true
        case .changeBodyInfo:
            break
        }
        return newState
    }
}
