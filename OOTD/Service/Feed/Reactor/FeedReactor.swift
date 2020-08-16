//
//  FeedReactor.swift
//  OOTD
//
//  Created by pony.tail on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import ReactorKit

class FeedReactor: Reactor {
    enum Action {
        case tapFilter
    }
    enum Mutation {
        case asdf
        case setLoading(Bool)
    }

    struct State {
        var isLoading: Bool = false
    }

    var initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapFilter:
            return Observable.just(.asdf)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .asdf:
            break

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
