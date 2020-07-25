//
//  HomeReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import ReactorKit

class HomeReactor: Reactor {
    enum Action {
        case add
    }
    
    enum Mutation {
        case showSelectPictureStyleSheet
    }
    
    struct State {
        var isSelectPicture: Bool = false
        var test: String = ""
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .add:
            return .just(.showSelectPictureStyleSheet)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showSelectPictureStyleSheet:
            newState.isSelectPicture = true
        }
        
        return newState
    }
}
