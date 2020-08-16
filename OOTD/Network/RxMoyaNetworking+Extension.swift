//
//  RxMoyaNetworking+Extension.swift
//  OOTD
//
//  Created by 이호찬 on 2020/08/16.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func filterTimeOutError(errorCompletion: (() -> Void)? = nil) -> Single<Response> {
        return catchError {
            if ($0 as NSError?)?.code != NSURLErrorCancelled {
                let alertController = UIAlertController(title: "네트워크 연결에 실패하였습니다.", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)

                UIApplication.targetViewController?.present(alertController, animated: true, completion: errorCompletion)
            }
            return .error($0)
        }
    }
}
