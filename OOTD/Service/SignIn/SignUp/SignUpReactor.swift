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

final class SignUpReactor: Reactor {
    enum Action {
        case updateText(String?)
        case toggleAgree
    }
    enum Mutation {
        case setText(String?)
        case toggleAgree
    }

    struct State {
        var text: String?
        var isAgree = false
        var isVaildName = false
    }

    var initialState = State()

    init() {
        initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateText(text):
            return Observable.just(.setText(text))

        case .toggleAgree:
            return Observable.just(.toggleAgree)
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
        }
        return newState
    }
}

extension SignUpReactor {
}
