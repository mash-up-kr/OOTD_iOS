//
//  String+Extension.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/12.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import Moya

extension String {
    func multipartFormData(_ name: String) -> MultipartFormData? {
        guard let stringData = self.data(using: .utf8) else {
            return nil
        }

        return MultipartFormData(provider: .data(stringData), name: name)
    }
}
