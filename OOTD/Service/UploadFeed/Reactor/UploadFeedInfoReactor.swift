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

    enum Action {
        case didTapInfoTargetButton(ViewInfoTarget)
        case didTapUploadButton
    }

    enum Mutation {
        case changeInfoView(ViewInfoTarget)
        case requestUpload
    }

    struct State {
        var showViewTarget: ViewInfoTarget = .date

        var feedBaseBody: FeedBaseBody
        var feedWeatherBody: FeedWeatherInfoBody = FeedWeatherInfoBody(weather: .CLEAR, temparature: 24)
        var styleIds: [Int] = []

        var uploadIsDone: Bool = false
        var uploadFail: Bool = false
    }

    var initialState: State

    init(_ image: UIImage?, _ content: String) {
        self.initialState = State(feedBaseBody: FeedBaseBody(image: image, content: content))
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapInfoTargetButton(let target):
            return Observable.just(.changeInfoView(target))
        case .didTapUploadButton:
            return Observable.just(.requestUpload)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.uploadFail = false

        switch mutation {
        case .changeInfoView(let viewTarget):
            newState.showViewTarget = viewTarget
        case .requestUpload:
            APIRequest.uploadFeed(feedInfo: state.feedBaseBody, weathrerInfo: state.feedWeatherBody, styleIds: state.styleIds)
                .subscribe(onSuccess: { [weak self] response in
                    print("good")
                    print(response.statusCode)
                    newState.uploadIsDone = true
                }, onError: { [weak self] err in
                    print(err)
                    newState.uploadFail = true
                })
        }
        return newState
    }
}
