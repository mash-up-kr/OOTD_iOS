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

    func previousMonth() -> Date {
        Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }

    func nextMonth() -> Date {
        Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }

    func changeDay(_ day: Int) -> Date {
        let components = Calendar.current.dateComponents(in: .current, from: self)
        let newDateComponents = DateComponents(year: components.year,
                                       month: components.month,
                                       day: day)
        guard let newDate = Calendar.current.date(from: newDateComponents) else {
            return Date()
        }
        return newDate
    }

    func firstDateWeekDay() -> Int {
        let components = Calendar.current.dateComponents(in: .current, from: self)

        let firstDateComponents = DateComponents(year: components.year,
                                       month: components.month,
                                       day: 1)
        guard let firstDate = Calendar.current.date(from: firstDateComponents) else {
            return 0
        }

        return Calendar.current.component(.weekday, from: firstDate)
    }

    func getDaysInMonth() -> Int {
        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        return numDays
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
