//
//  OOTD+User.swift
//  OOTD
//
//  Created by pony.tail on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

extension OOTD {
    class User {
        // To. hochan 임시로 내 토큰 사용했음!
        var name = "포니"
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6Mn0.FdCGmwbTqAohz4OWA1CKdtZxsNhE9RDTXgAfoTliR6A"

        var preference = Preference()
        var location = Location()

        struct Location {
            var weather: FeedWeatherType = .CLEAR
        }

        struct Preference {
            var temperature = Temperature()

            struct Temperature {
                var value: Int {
                    get { UserDefaults.preference.value(forKey: "Preference::Temperature::value") as? Int ?? 24 }
                    set { UserDefaults.preference.set(newValue, forKey: "Preference::Temperature::value") }
                }
                var range: Int {
                    get { UserDefaults.preference.value(forKey: "Preference::Temperature::range") as? Int ?? 3 }
                    set { UserDefaults.preference.set(newValue, forKey: "Preference::Temperature::range") }
                }

                var min: Int {
                    value - range
                }
                var max: Int {
                    value + range
                }
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
