//
//  FilterReactor.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/04.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit

class FilterReactor: Reactor {
    enum Action {
        case didChangeStyles([Style])
        case didChangeWeather(FeedWeatherType)
        case didChangeTemperature(Int)
        case complete
    }

    enum Mutation {
        case changeStyles([Style])
        case changeWeather(FeedWeatherType)
        case changeTemperature(Int)
        case updateFilter
    }

    struct State {
        var complete = false
        var filter = Filter()
    }

    var initialState = State()
    var filterPublishSubject = PublishSubject<Filter>()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didChangeStyles(let styles):
            return Observable.just(.changeStyles(styles))
        case .didChangeWeather(let weather):
            return Observable.just(.changeWeather(weather))
        case .didChangeTemperature(let temperature):
            return Observable.just(.changeTemperature(temperature))
        case .complete:
            return Observable.just(.updateFilter)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .changeStyles(let styles):
            newState.filter.styles = styles
        case .changeWeather(let weather):
            newState.filter.weather.weather = weather
        case .changeTemperature(let temperature):
            newState.filter.weather.temparature = temperature
        case .updateFilter:
            newState.complete = true
            filterPublishSubject.onNext(newState.filter)
        }

        return newState
    }
}
