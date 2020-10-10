//
//  UploadFeedReactor.swift
//  OOTD
//
//  Created by 이호찬 on 2020/07/26.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

final class UploadFeedReactor: Reactor {
    enum Action {
        case didTapImageButton
        case contentTextDidChange(String)
        case didTapNextButton
        case userSelectImage(UIImage)
    }

    enum Mutation {
        case showSelectPictureStyleSheet
        case setLoading(Bool)
        case updateContentText(String)
        case initiateFeedInfoViewController
        case setImage(UIImage)
    }

    struct State {
        var isLoading: Bool = false
        var showSelectPictureStyleSheet: Bool = false
        var feedImage: UIImage?
        var content: String = ""
        var feedInfoViewController: UIViewController?
    }

    var initialState = State()

    init(feedImage: UIImage?) {
        initialState = .init(feedImage: feedImage)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapImageButton:
            return Observable.just(.showSelectPictureStyleSheet)
        case .contentTextDidChange(let text):
            return Observable.just(.updateContentText(text))
        case .didTapNextButton:
            return Observable.just(.initiateFeedInfoViewController)
        case .userSelectImage(let selectedImage):
            return .just(.setImage(selectedImage))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.feedInfoViewController = nil
        newState.showSelectPictureStyleSheet = false

        switch mutation {
        case .showSelectPictureStyleSheet:
            newState.showSelectPictureStyleSheet = true
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case .updateContentText(let text):
            newState.content = text
        case .initiateFeedInfoViewController:
            newState.feedInfoViewController = UploadFeedInfoViewController.newViewController(newState.feedImage, newState.content)
        case .setImage(let selectedImage):
            newState.feedImage = selectedImage
        }

        return newState
    }
}
