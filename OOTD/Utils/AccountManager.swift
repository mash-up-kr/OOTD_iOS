//
//  AccountManager.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/06.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation

final class AccountManager {
    static var authToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "authToken")
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: "authToken")
            } else {
                UserDefaults.standard.set(newValue, forKey: "authToken")
            }
        }
    }
}
