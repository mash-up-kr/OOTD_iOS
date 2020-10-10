//
//  FeedCommentReactor.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import ReactorKit
import Moya

class FeedCommentReactor: Reactor {
    enum Action {
        case setComment(message: String, feed: Feed)
        case startUpload
        case setEditing(Bool)
        case editComment(String?)
    }

    enum Mutation {
        case setComment(FeedComment)
        case startUpload
        case setEditing(Bool)
        case editComment(String?)
    }

    struct State {
        var feed: Feed
        var comments: [FeedComment]

        var isEditing = false
        var commentEdited: String?
        var commentCompleted: String?
    }

    var initialState: State

    init(feed: Feed, comments: [FeedComment]) {
        initialState = State(feed: feed, comments: comments)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setComment(message, feed):
            return setComment(message: message, feed: feed)
                .asObservable()
                .mapData(Comment.self)
                .map { .setComment(FeedComment(id: $0.commentId,
                                               userNickname: OOTD.shared.user.name,
                                               message: $0.message,
                                               createdDate: Date()))
                }
        case .startUpload:
            return Observable.just(.startUpload)
        case let .setEditing(isEditing):
            return Observable.just(.setEditing(isEditing))
        case let .editComment(message):
            return Observable.just(.editComment(message))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setComment(let comment):
            newState.comments.append(comment)
        case .startUpload:
            newState.commentCompleted = newState.commentEdited
        case .setEditing(let isEditing):
            newState.isEditing = isEditing
        case .editComment(let message):
            newState.commentEdited = message
        }

        return newState
    }

    private struct Comment: Decodable {
        let commentId: Int
        let message: String
    }
}

extension FeedCommentReactor {
    private func setComment(message: String, feed: Feed) -> Single<Response> {
        APIRequest.setComments(message: message, feed: feed)
    }
}
