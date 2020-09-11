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
        case requestFeed(parameters: [String: Any])
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
        case.requestFeed(let parameters):
            return Observable.concat([
                Observable.just(.setLoading(true)),

                getFeed(parameters: parameters)
                    .asObservable()
                    .mapData(FeedData.self)
                    .map { .setFeed($0.posts) }
                    .catchErrorJustReturn(.setLoading(false)),

                Observable.just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setFeed(feed):
            newState.feed = feed

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

extension FeedReactor {
    private func getFeed(parameters: [String: Any]) -> Single<Response> {
        APIRequest.getFeed(parameters: parameters)
    }
}
