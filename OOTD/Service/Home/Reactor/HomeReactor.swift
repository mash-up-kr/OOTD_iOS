//
//  HomeReactor.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class HomeReactor: Reactor {
    enum Action {
        case didTapFilter
        case requestWeather
    }

    enum Mutation {
        case showStyleViewController
        case locationWeatherData(WeatherData)
        case failToNetwork
    }

    struct State {
        var styleViewController: StyleViewController?
        var weatherData: WeatherData?
        var isFailToNetwork: Bool = false
    }

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapFilter:
            return .just(.showStyleViewController)

        case .requestWeather:
            return Observable.concat([
                APIRequest
                    .getWeather()
                    .asObservable()
                    .mapData(WeatherData.self)
                    .map { .locationWeatherData($0) }
                    .catchErrorJustReturn(.failToNetwork)
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isFailToNetwork = false

        switch mutation {
        case .showStyleViewController:
            newState.styleViewController = styleViewController()

        case .locationWeatherData(let data):
            newState.weatherData = data

        case .failToNetwork:
            newState.isFailToNetwork = true
        }
        return newState
    }

    private func styleViewController() -> StyleViewController? {
        StyleViewController.instantiate()
    }
}
