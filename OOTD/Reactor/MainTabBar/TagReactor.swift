//
//  TagReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import ReactorKit
import RxSwift

class TagReactor: Reactor {
    enum Action {
    }

    enum Mutation {
    }

    struct State {
    }

    var initialState: State = State()

    var ssSubject = PublishSubject<Tag>()

//    func mutate(action: Action) -> Observable<Mutation> {
//
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//
//    }
}
