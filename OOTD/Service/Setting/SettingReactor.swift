//
//  SettingReactor.swift
//  OOTD
//
//  Created by Hochan Lee on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import ReactorKit

final class SettingReactor: Reactor {
    enum Action {
        case setSelectedStyles([Style])
        case updateProfileImage(UIImage?)
    }
    enum Mutation {
        case setSelectedStyles([Style])
        case setProfileImage(UIImage?)
        case setLoading(Bool)
    }

    struct State {
        var isLoading: Bool = false
        var selectedStyles = [Style]()
        var profileImage: UIImage?
    }

    var initialState = State()

    init() {
        initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setSelectedStyles(styles):
            return Observable.just(.setSelectedStyles(styles))

        case let .updateProfileImage(image):
            return Observable.just(.setProfileImage(image))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setSelectedStyles(styles):
            newState.selectedStyles = styles

        case let .setProfileImage(image):
            newState.profileImage = image

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

extension SettingReactor {
}
