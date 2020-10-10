//
//  Weather.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/10/10.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

struct WeatherData: Decodable, Equatable {
    var windChillTemp: Int
    var temp: Int
    var maxTemp: Int
    var minTemp: Int
    var weather: Weather
    var precipitation: String

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.windChillTemp == rhs.windChillTemp &&
           lhs.temp == rhs.temp &&
           lhs.maxTemp == rhs.maxTemp &&
           lhs.minTemp == rhs.minTemp &&
           lhs.weather == rhs.weather &&
           lhs.precipitation == rhs.precipitation
    }
}

enum Weather: String, Decodable {
    case CLEAR
    case CLOUDS
    case RAIN
    case SNOW
    case THUNDERSTORM

    var homeImage: UIImage? {
        switch self {
        case .CLEAR:
            return UIImage(named: "homeiconSun")
        case .CLOUDS:
            return UIImage(named: "homeiconCloud")
        case .RAIN:
            return UIImage(named: "homeiconRain")
        case .SNOW:
            return UIImage(named: "homeiconSnow")
        case .THUNDERSTORM:
            return UIImage(named: "homeiconThunderstom")
        }
    }
}
