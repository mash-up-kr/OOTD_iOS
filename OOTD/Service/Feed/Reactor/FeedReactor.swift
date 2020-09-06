//
//  FeedReactor.swift
//  OOTD
//
//  Created by pony.tail on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import ReactorKit
import RxSwift
import Moya

class FeedReactor: Reactor {
    enum Action {
        case requestFeed
    }

    enum Mutation {
        case setFeed([Feed])
        case setLoading(Bool)
    }

    struct State {
        var feed = [Feed]()
        var isLoading = false
    }

    var initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case.requestFeed:
            return Observable.concat([
                Observable.just(.setLoading(true)),

                getFeed()
                    .asObservable()
                    .mapData([Feed].self)
                    .map { .setFeed($0) }
                    .catchErrorJustReturn(.setLoading(false)),

                Observable.just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setFeed(feed):
            // 임시로 피드 좀 늘림 ㅠㅠ
            if let photo = feed.first {
                newState.feed = Array(repeating: photo, count: 10)
                return newState
            }
            newState.feed = feed

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

extension FeedReactor {
    private func getFeed() -> Single<Response> {
        APIRequest.getFeed()
    }
}
