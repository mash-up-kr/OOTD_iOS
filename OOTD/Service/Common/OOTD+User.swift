//
//  OOTD+User.swift
//  OOTD
//
//  Created by pony.tail on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

extension OOTD {
    struct User {
        // To. hochan 임시로 내 토큰 사용했음!
        let name = "포니"
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6Mn0.FdCGmwbTqAohz4OWA1CKdtZxsNhE9RDTXgAfoTliR6A"

        var preference = Preference()
        let location = Location()

        struct Location {
            let weather = "CLEAR"
        }

        struct Preference {
            let temperature = Temperature()

            struct Temperature {
                let min = 21
                let max = 23
            }

            private var styleIds: [Int] {
                get { UserDefaults.preference.array(forKey: "Preference::styleIds") as? [Int] ?? [] }
                set { UserDefaults.preference.set(newValue, forKey: "Preference::styleIds") }
            }

            var styles: [Style] {
                get { styleIds.compactMap { OOTD.shared.styles.first(id: $0) } }
                set { styleIds = newValue.map { $0.id } }
            }
        }
    }
}

fileprivate extension UserDefaults {
    static let preference = UserDefaults(suiteName: "Preference")!
}