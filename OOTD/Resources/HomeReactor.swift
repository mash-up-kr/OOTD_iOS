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
        case showTagViewController
        case createAddFeedViewController(UIImage)
    }

    struct State {
        var isSelectPicture: Bool = false
        var tagViewController: TagViewController?
        var selectedImage: UIImage?
    }

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapHeaderAddFeedButton:
            return .just(.showSelectPictureStyleSheet)
        case .didTapFilter:
            return .just(.showTagViewController)
        case let .selectedPicture(image):
            return .just(.createAddFeedViewController(image))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showSelectPictureStyleSheet:
            newState.isSelectPicture = true
        case .showTagViewController:
            newState.tagViewController = tagViewController()
        case let .createAddFeedViewController(image):
            newState.selectedImage = image
        }
        return newState
    }

    private func tagViewController() -> TagViewController? {
        return TagViewController.instantiate()
    }
}
