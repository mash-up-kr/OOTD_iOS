//
//  FeedBaseBody.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/12.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import Moya

struct FeedBaseBody {
    var image: UIImage?
    var content: String

    var imageMultipartFormData: MultipartFormData? {
        guard let image = image, let imageData = image.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        return MultipartFormData(provider: .data(imageData), name: "uploadFile", fileName: "uploadFile", mimeType: "image/jpeg")
    }

    var contentMultipartFormData: MultipartFormData? {
        content.multipartFormData("message")
    }
}
