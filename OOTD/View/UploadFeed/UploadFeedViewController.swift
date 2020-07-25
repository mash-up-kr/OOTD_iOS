//
//  UploadFeedViewController.swift
//  OOTD
//
//  Created by 이호찬 on 2020/07/26.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class UploadFeedViewController: UIViewController, StoryboardBuildable ,StoryboardView {
    static func newViewController(image: UIImage) -> UIViewController {
        let viewController = UploadFeedViewController.instantiate()
        viewController.reactor = UploadFeedReactor(feedImage: image)
        
        return viewController
    }
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedImageView.image = reactor?.initialState.feedImage 
    }
    
}

extension UploadFeedViewController {
    func bind(reactor: UploadFeedReactor) {
        
        
    }
}
