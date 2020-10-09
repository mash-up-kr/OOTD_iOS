//
//  FeedComment.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

struct FeedComment: Decodable {
    let id: Int
    let userNickname: String
    let message: String
    let createdDate: String

    private var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "YY년 M월 d일 E요일"
        return dateFormatter.date(from: createdDate)
    }

    var daysFromToday: String {
        let calendar = Calendar.current
        guard let date = date else {
            return ""
        }
        if calendar.isDateInToday(date) {
            return "오늘"
        }
        guard let days = calendar.dateComponents([.day], from: date, to: Date()).day else {
            return ""
        }
        if days < 0 {
            return ""
        }
        return "\(days)일전"
    }
}

extension FeedComment {
    static let samples = [
        FeedComment(id: 1, userNickname: "위대한 개미", message: "우와 너무 멋있는 룩이네요. 저도 이렇게 입어야겠어요!", createdDate: "20년 10월 2일 금요일"),
        FeedComment(id: 2, userNickname: "BackToFutrue", message: "So Cooooool!", createdDate: "20년 10월 8일 목요일"),
        FeedComment(id: 3, userNickname: "초록초록", message: "오랜만에 뵈어요! 날씨 추운데 잘 지내고 계신가요?? 저번에 인사드리고 하하하. 진짜 옷 개 잘입으시네요. 셔츠는 어디서 구매하신건가요?", createdDate: "20년 10월 9일 금요일")
    ]
}
