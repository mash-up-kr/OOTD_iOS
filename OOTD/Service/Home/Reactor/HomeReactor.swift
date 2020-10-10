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
        case didTapHeaderAddFeedButton
        case didTapFilter
        case selectedPicture(UIImage)
        case requestWeather
    }

    enum Mutation {
        // TODO: 이름 고민중
        case showSelectPictureStyleSheet
        case showStyleViewController
        case createAddFeedViewController(UIImage)
        case locationWeatherData(WeatherData)
        case failToNetwork
    }

    struct State {
        var isSelectPicture: Bool = false
        var styleViewController: StyleViewController?
        var selectedImage: UIImage?
        var weatherData: WeatherData?
        var isFailToNetwork: Bool = false
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
        newState.isSelectPicture = false
        newState.isFailToNetwork = false

        switch mutation {
        case .showSelectPictureStyleSheet:
            newState.isSelectPicture = true

        case .showStyleViewController:
            newState.styleViewController = styleViewController()

        case let .createAddFeedViewController(image):
            newState.selectedImage = image

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
