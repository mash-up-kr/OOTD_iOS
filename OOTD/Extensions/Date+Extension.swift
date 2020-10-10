//
//  Date+Extension.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/12.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

extension Date {
    func patternizedString(_ pattern: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: self)
    }

    func koreaWeekDay() -> String {
        switch Calendar.current.component(.weekday, from: self) {
        case 1:
            return "일요일"
        case 2:
            return "월요일"
        case 3:
            return "화요일"
        case 4:
            return "수요일"
        case 5:
            return "목요일"
        case 6:
            return "금요일"
        case 7:
            return "토요일"
        default:
            return ""
        }
    }

    func test() {
        // Get right now as it's `DateComponents`.
        let now = Calendar.current.dateComponents(in: .current, from: Date())

        // Create the start of the day in `DateComponents` by leaving off the time.
        let today = DateComponents(year: now.year, month: now.month, day: now.day)
        let dateToday = Calendar.current.date(from: today)!
        print(dateToday.timeIntervalSince1970)

        // Add 1 to the day to get tomorrow.
        // Don't worry about month and year wraps, the API handles that.
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
        let dateTomorrow = Calendar.current.date(from: tomorrow)!
        print(dateTomorrow.timeIntervalSince1970)
    }
}
// 7 ( 토요일 )
