//
//  HomeReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit

class HomeReactor: Reactor {
    enum Action {
        case didTapHeaderAddFeedButton
        case didTapFilter
        case selectedPicture(UIImage)
    }

    enum Mutation {
        // TODO: 이름 고민중
        case showSelectPictureStyleSheet
        case showStyleViewController
        case createAddFeedViewController(UIImage)
    }

    struct State {
        var isSelectPicture: Bool = false
        var styleViewController: StyleViewController?
        var selectedImage: UIImage?
    }

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapHeaderAddFeedButton:
            return .just(.showSelectPictureStyleSheet)
        case .didTapFilter:
            return .just(.showStyleViewController)
        case let .selectedPicture(image):
            return .just(.createAddFeedViewController(image))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isSelectPicture = false
        switch mutation {
        case .showSelectPictureStyleSheet:
            newState.isSelectPicture = true
        case .showStyleViewController:
            newState.styleViewController = styleViewController()
        case let .createAddFeedViewController(image):
            newState.selectedImage = image
        }
        return newState
    }

    private func styleViewController() -> StyleViewController? {
        StyleViewController.instantiate()
    }
}
