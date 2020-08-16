//
//  UploadFeedReactor.swift
//  OOTD
//
//  Created by 이호찬 on 2020/07/26.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

final class UploadFeedReactor: Reactor {
    enum Action {
        case asdf
    }
    enum Mutation {
        case asdf
        case setLoading(Bool)
    }

    struct State {
        var isLoading: Bool = false
        var feedImage: UIImage?
    }

    var initialState = State()

    init(feedImage: UIImage?) {
        initialState = .init(feedImage: feedImage)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .asdf:
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

extension UploadFeedReactor {
}
