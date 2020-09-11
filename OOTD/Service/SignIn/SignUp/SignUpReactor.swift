//
//  SignUpReactor.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit
import Moya

final class SignUpReactor: Reactor {
    enum Action {
        case updateText(String?)
        case toggleAgree
        case requestSignUp
    }
    enum Mutation {
        case setText(String?)
        case toggleAgree
        case setUserInfo(UserInfo)
    }

    struct State {
        var text: String?
        var userInfo: UserInfo?
        var isAgree = false
        var isVaildName = false
        var isLoading = false
        let uId: String
    }

    var initialState = State(uId: "")

    init(uId: String) {
        initialState = State(uId: uId)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateText(text):
            return Observable.just(.setText(text))

        case .toggleAgree:
            return Observable.just(.toggleAgree)

        case .requestSignUp:
            print(AccountManager.authToken ?? "sfljkasdkl")
            return signUp()
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
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setText(text):
            newState.text = text
            newState.isVaildName = newState.text ?? "" != ""

        case .toggleAgree:
            newState.isAgree.toggle()

        case let .setUserInfo(userInfo):
            newState.userInfo = userInfo
        }
        return newState
    }
}

extension SignUpReactor {
    private func signUp() -> Single<Response> {
        APIRequest.signUp(uId: currentState.uId,
                          authType: "APPLE",
                          nickname: currentState.text ?? "",
                          styleIds: [1, 2, 3])
    }
}
