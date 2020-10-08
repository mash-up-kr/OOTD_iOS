//
//  SettingReactor.swift
//  OOTD
//
//  Created by Hochan Lee on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ReactorKit

final class SettingReactor: Reactor {
    enum Action {
        case setSelectedStyles([Style])
    }
    enum Mutation {
        case setSelectedStyles([Style])
        case setLoading(Bool)
    }

    struct State {
        var isLoading: Bool = false
        var selectedStyles = [Style]()
    }

    var initialState = State()

    init() {
        initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setSelectedStyles(styles):
            return Observable.just(.setSelectedStyles(styles))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setSelectedStyles(styles):
            newState.selectedStyles = styles

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

extension SettingReactor {
}
