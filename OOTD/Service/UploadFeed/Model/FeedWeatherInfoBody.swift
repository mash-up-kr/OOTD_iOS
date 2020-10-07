//
//  FeedWeatherInfoBody.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/12.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import Moya

struct FeedWeatherInfoBody {
    var weather: FeedWeatherType
    var temparature: Int

    var weatherMultipartFormData: MultipartFormData? {
        weather.rawValue.multipartFormData("weather")
    }

    var temparatureFormData: MultipartFormData? {
        String(temparature).multipartFormData("temperature")
    }

    mutating func changeWeather(_ weather: FeedWeatherType) {
        self.weather = weather
    }

    mutating func changeTemparature(_ temparature: Int) {
        self.temparature = temparature
    }
}

enum FeedWeatherType: String, CaseIterable {
    case CLEAR
    case CLOUDS
    case RAIN
    case SNOW
    case THUNDERSTORM

    var index: Int {
        for (index, type) in Self.allCases.enumerated() where self == type {
            return index
        }
        return .zero
    }

    var imageName: String {
        switch self {
        case .CLEAR: return "imgSun"
        case .CLOUDS: return "imgCloud"
        case .RAIN: return "imgRain"
        case .SNOW: return "imgSnow"
        case .THUNDERSTORM: return "imgThunderstorm"
        }
    }
}
