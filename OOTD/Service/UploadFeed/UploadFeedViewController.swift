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

final class UploadFeedViewController: UIViewController, StoryboardBuildable, StoryboardView {
    @IBOutlet weak var feedImageButton: UIButton!
    @IBOutlet weak var feedContentTextField: UITextField!

    var disposeBag = DisposeBag()
    weak var delegate: RefreshMainFeedDelegate?

    static func newViewController(image: UIImage) -> UIViewController {
        let viewController = UploadFeedViewController.instantiate()
        viewController.reactor = UploadFeedReactor(feedImage: image)
        let resultViewController = UINavigationController.withNavigationBarHidden(viewController)
        resultViewController.modalPresentationStyle = .fullScreen
        return resultViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        feedImageButton.setImage(reactor?.initialState.feedImage, for: .normal)
    }

    @IBAction func didTapCloseButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func didTapNextButtonAction(_ sender: Any) {
        reactor?.action.onNext(.didTapNextButton)
    }
}

extension UploadFeedViewController {
    func bind(reactor: UploadFeedReactor) {
        feedContentTextField.rx.text.orEmpty
            .map { UploadFeedReactor.Action.contentTextDidChange($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.feedInfoViewController }
            .subscribe(onNext: { [weak self] uploadFeedInfoViewController in
                guard let uploadFeedInfoViewController = uploadFeedInfoViewController as? UploadFeedInfoViewController else {
                    return
                }
                uploadFeedInfoViewController.delegate = self?.delegate
                self?.navigationController?.pushViewController(uploadFeedInfoViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
