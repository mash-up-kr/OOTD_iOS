//
//  SignUpViewController.swift
//  OOTD
//
//  Created by 이호찬 on 2020/09/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class SignUpViewController: UIViewController, StoryboardBuildable, StoryboardView {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textFieldLineView: UIView!
    @IBOutlet private weak var textFieldHintLabel: UILabel!
    @IBOutlet private weak var checkBoxImageView: UIImageView!
    @IBOutlet private weak var agreementBackgroundView: UIView!
    @IBOutlet private weak var privacyLinkButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!

    var disposeBag = DisposeBag()
}

extension SignUpViewController {
    func bind(reactor: SignUpReactor) {
        textField.rx.text
            .map { Reactor.Action.updateText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.isAgree }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.checkBoxImageView.image = $0 ? UIImage(named: "checkBoxFill24") : UIImage(named: "checkBoxEmpty24")
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isVaildName }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let color: UIColor = $0 ? .blueKey : .grey07
                self.textFieldLineView.backgroundColor = color
                self.textFieldHintLabel.textColor = color
                self.textFieldHintLabel.text = $0 ? "닉네임을 입력해주세요." : "가능한 닉네임입니다."
            })
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.isAgree && $0.isVaildName }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.nextButton.isEnabled = $0
                self.nextButton.backgroundColor = $0 ? .blueKey : .grey03
            })
            .disposed(by: disposeBag)
    }
}