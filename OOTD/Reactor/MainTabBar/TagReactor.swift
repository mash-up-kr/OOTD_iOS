//
//  TagReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import ReactorKit
import RxSwift
import Moya

class TagReactor: Reactor {
    enum Action {
        case requestTags
    }

    enum Mutation {
        case setTags([Tag])
        case setIsLoading(Bool)
    }

    struct State {
        var tags: [Tag] = []
        var isLoading = false
    }

    var initialState: State = State()

    var ssSubject = PublishSubject<Tag>()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .requestTags:
            return Observable.concat([
                Observable.just(.setIsLoading(true)),

                getStyles()
                    .asObservable()
                    .mapData([Tag].self)
                    .map { .setTags($0) }
                    .catchErrorJustReturn(.setIsLoading(false)),

                Observable.just(.setIsLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setTags(tags):
            newState.tags = tags

        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }
}

extension TagReactor {
    private func getStyles() -> Single<Response> {
        APIRequest.getStyles()
    }
}
