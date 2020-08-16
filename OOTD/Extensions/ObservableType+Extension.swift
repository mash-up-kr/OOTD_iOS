//
//  ObservableType+Extension.swift
//  OOTD
//
//  Created by 이호찬 on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import Foundation
import RxSwift
import RxMoya
import Moya

extension ObservableType where Self.Element == Moya.Response {
    func mapData<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = "data", using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Observable<D> {
        return flatMap { Observable.just(try $0.mapData(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}
