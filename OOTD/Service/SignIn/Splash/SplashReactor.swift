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
        case setVaild(OOTDApi<UserId>)
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
                .map { Mutation.setVaild($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setVaild(ootd):
            print(ootd)
            newState.isValid = ootd.code == 200

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
