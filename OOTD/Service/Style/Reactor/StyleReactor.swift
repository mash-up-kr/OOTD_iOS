//
//  StyleReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import ReactorKit
import RxSwift
import Moya

class StyleReactor: Reactor {
    enum Action {
        case requestStyles
    }

    enum Mutation {
        case setStyles([Style])
        case setIsLoading(Bool)
    }

    struct State {
        var styles: [Style] = OOTD.shared.styles
        var isLoading = false
    }

    var initialState: State = State()
    var stylesPublishSubject = PublishSubject<[Style]>()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .requestStyles:
            return Observable.concat([
                Observable.just(.setIsLoading(true)),

                getStyles()
                    .asObservable()
                    .mapData([Style].self)
                    .map { .setStyles($0) }
                    .catchErrorJustReturn(.setIsLoading(false)),

                Observable.just(.setIsLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setStyles(styles):
            newState.styles = styles

        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }
}

extension StyleReactor {
    private func getStyles() -> Single<Response> {
        APIRequest.getStyles()
    }
}
