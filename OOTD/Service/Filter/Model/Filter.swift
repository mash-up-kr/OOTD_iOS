//
//  Filter.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/05.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

struct Filter {
    var weather: FeedWeatherInfoBody
    var styles: [Style]

    init() {
        weather = FeedWeatherInfoBody(weather: .CLEAR, temparature: 24)
        styles = OOTD.shared.user.preference.styles
    }

    init(weather: FeedWeatherInfoBody, styles: [Style]) {
        self.weather = weather
        self.styles = styles
    }
}
