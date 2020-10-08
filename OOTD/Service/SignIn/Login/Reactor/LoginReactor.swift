//
//  LoginReactor.swift
//  OOTD
//
//  Created by Hochan Lee on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ReactorKit

final class LoginReactor: Reactor {
    enum Action {
        case requestSignIn(String, String)
    }
    enum Mutation {
        case setUserInfo(UserInfo)
        case setLoading(Bool)
        case goToSignUp
        case setUserAuth(String, String)
    }

    struct State {
        var isLoading: Bool = false
        var userInfo: UserInfo?
        var goToSignUp = false
        var uId: String?
        var authType: String?
    }

    var initialState = State()

    init() {
        initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .requestSignIn(uId, authType):
            return Observable.concat([
                Observable.just(.setLoading(true)),

                Observable.just(.setUserAuth(uId, authType)),

                signIn(uId: uId, authType: authType)
                    .asObservable()
                    .do(onNext: { response in
                        print(response)
                        if let authToken = response.response?.allHeaderFields["Access-Token"] as? String {
                            AccountManager.authToken = authToken
                        }
                    })
                    .do(onError: {
                        print($0.localizedDescription)
                    })
                    .mapData(UserInfo.self)
                    .map { .setUserInfo($0) }
                    .catchErrorJustReturn(.goToSignUp),

                Observable.just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setUserInfo(userInfo):
            newState.userInfo = userInfo

        case let .setLoading(isLoading):
            newState.isLoading = isLoading

        case let .setUserAuth(uId, authType):
            newState.uId = uId
            newState.authType = authType

        case .goToSignUp:
            newState.goToSignUp = true
        }
        return newState
    }
}

extension LoginReactor {
    private func signIn(uId: String, authType: String) -> Single<Response> {
        APIRequest.signIn(uId: uId, authType: authType)
    }
}
