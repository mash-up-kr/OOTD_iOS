//
//  SelectDateCalendarReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

final class SelectDateCalendarReactor: Reactor {
    enum Action {
        case changeNextMonth
        case changePreviousMonth
        case selectDay(_ day: Int)
    }

    enum Mutation {
        case changeNextMonth
        case changePreviousMonth
        case setSelectedDate(_ day: Int)
    }

    struct State {
        var dateForCalendarUI: Date = Date()
        var selectedDate: Date = Date()
        var numberOfCell: Int = 0
    }

    var initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeNextMonth:
            return .just(.changeNextMonth)
        case .changePreviousMonth:
            return .just(.changePreviousMonth)
        case .selectDay(let day):
            return .just(.setSelectedDate(day))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .changeNextMonth:
            newState.dateForCalendarUI = newState.dateForCalendarUI.nextMonth()
            newState.numberOfCell = newState.dateForCalendarUI.getDaysInMonth()
        case .changePreviousMonth:
            newState.dateForCalendarUI = newState.dateForCalendarUI.previousMonth()
            newState.numberOfCell = newState.dateForCalendarUI.getDaysInMonth()
        case .setSelectedDate(let day):
            newState.selectedDate = newState.dateForCalendarUI.changeDay(day)
        }

        return newState
    }
}

// 처음 시작 위치
// 일수
// 셀 선택 막기

//private func getDaysCountOfDate() -> Int {
//    return 0
//}
