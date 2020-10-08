//
//  SplashReactor.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ReactorKit

final class SplashReactor: Reactor {
    enum Action {
        case checkAuthToken
    }
    enum Mutation {
        case setVaild(Bool)
        case setLoading(Bool)
    }

    struct State {
        var isLoading = false
        var isValid: Bool?
    }

    var initialState = State()

    init() {
        initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkAuthToken:
            return checkAuthToken()
                .asObservable()
                .map(OOTDApi<UserId>.self)
                .map { $0.code == 200 }
                .map { Mutation.setVaild($0) }
                .catchErrorJustReturn(.setVaild(false))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setVaild(isValid):
            newState.isValid = isValid

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

extension SplashReactor {
    private func checkAuthToken() -> Single<Response> {
        APIRequest.checkAuthToken()
    }
}
