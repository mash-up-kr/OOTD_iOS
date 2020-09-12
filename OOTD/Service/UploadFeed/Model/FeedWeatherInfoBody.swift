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
}

enum FeedWeatherType: String {
    case CLEAR
    case CLOUDS
    case RAIN
    case SNOW
    case THUNDERSTORM
}
