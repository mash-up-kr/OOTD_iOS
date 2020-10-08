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
        case requestSignUp([Int])
    }

    enum Mutation {
        case setStyles([Style])
        case setIsLoading(Bool)
        case setUserInfo(UserInfo)
    }

    struct State {
        var styles: [Style] = OOTD.shared.styles
        var isLoading = false
        var userInfo: UserInfo?
        var uId = ""
        var nickname = ""
        var authType: String?
    }

    init() {
        initialState = State()
    }

    init(uId: String, authType: String, nickname: String) {
        initialState = State(uId: uId, nickname: nickname, authType: authType)
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

        case let .requestSignUp(styleIds):
            return Observable.concat([
                Observable.just(.setIsLoading(true)),

                signUp(styleIds: styleIds)
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

        case let .setUserInfo(userInfo):
            newState.userInfo = userInfo
            OOTD.shared.user.name = userInfo.nickname
        }

        return newState
    }
}

extension StyleReactor {
    private func getStyles() -> Single<Response> {
        APIRequest.getStyles()
    }

    private func signUp(styleIds: [Int]) -> Single<Response> {
        APIRequest.signUp(uId: currentState.uId,
                          authType: currentState.authType ?? "APPLE",
                          nickname: currentState.nickname,
                          styleIds: styleIds)
    }
}
