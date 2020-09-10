//
//  UploadFeedInfoReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/10.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

final class UploadFeedInfoReactor: Reactor {
    enum ViewInfoTarget {
        case date
        case style
        case location
        case weather
    }

    enum Action {
        case didTapInfoTargetButton(ViewInfoTarget)
    }

    enum Mutation {
        case changeInfoView(ViewInfoTarget)
    }

    struct State {
        var uploadImage: UIImage?
        var uploadContent: String
        var showViewTarget: ViewInfoTarget = .date
    }

    var initialState: State

    init(_ image: UIImage?, _ content: String) {
        self.initialState = State(uploadImage: image, uploadContent: content)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapInfoTargetButton(let target):
            return Observable.just(.changeInfoView(target))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .changeInfoView(let viewTarget):
            newState.showViewTarget = viewTarget
        }
        return newState
    }
}
