//
//  FeedDetailReactor.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import ReactorKit
import Moya

class FeedDetailReactor: Reactor {
    enum Action {
        case requestComments(feed: Feed)
    }

    enum Mutation {
        case setComments([FeedComment])
    }

    struct State {
        var feed: Feed
        var comments: [FeedComment]
    }

    var initialState: State

    init(feed: Feed) {
        initialState = State(feed: feed, comments: [])
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .requestComments(let feed):
            return getComments(for: feed)
                .asObservable()
                .mapData([FeedComment].self)
                .map { .setComments($0) }
                .catchErrorJustReturn(.setComments([]))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setComments(let comments):
            newState.comments = comments
        }

        return newState
    }
}

extension FeedDetailReactor {
    private func getComments(for feed: Feed) -> Single<Response> {
        APIRequest.getComments(feed: feed)
    }
}
