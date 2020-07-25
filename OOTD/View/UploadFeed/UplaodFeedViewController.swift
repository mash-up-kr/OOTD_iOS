//
//  UplaodFeedViewController.swift
//  OOTD
//
//  Created by 이호찬 on 2020/07/26.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class UplaodFeedViewController: UIViewController, StoryboardBuildable ,StoryboardView {
    @IBOutlet weak var feedImageView: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor = UploadFeedReactor(feedImage: nil) // 나중에 외부에서 주입하도록 변경
        
        feedImageView.image = reactor?.initialState.feedImage 
    }
    
}

extension UplaodFeedViewController {
    func bind(reactor: UploadFeedReactor) {
        
        
    }
}
