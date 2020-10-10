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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.reactor = UploadFeedReactor(feedImage: nil)
    }

    static func newViewController(image: UIImage) -> UIViewController {
        let viewController = UploadFeedViewController.instantiate()
        viewController.reactor = UploadFeedReactor(feedImage: image)
        let resultViewController = UINavigationController.withNavigationBarHidden(viewController)
        resultViewController.modalPresentationStyle = .fullScreen
        return resultViewController
    }

    lazy var selectPictureActionController: UIAlertController = {
        let alertController = UIAlertController(title: "사진 선택", message: "피드에 추가할 사진을 선택해주세요!", preferredStyle: .actionSheet)

        let takePictureAction = UIAlertAction(title: "사진 찍기", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
            }
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let selectPictureFromGallery = UIAlertAction(title: "갤러리에서 선택하기", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소하기", style: .cancel) {    _ in
            print("취소 하기")
        }

        alertController.addAction(takePictureAction)
        alertController.addAction(selectPictureFromGallery)
        alertController.addAction(cancelAction)

        return alertController
    }()
    lazy var imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
    }

    @IBAction func didTapImageButton(_ sender: Any) {
        reactor?.action.onNext(.didTapImageButton)
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
            .map { $0.showSelectPictureStyleSheet }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let styleSheetViewController = self?.selectPictureActionController else {
                    return
                }
                self?.present(styleSheetViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.feedImage }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                        self?.feedImageButton.setImage($0, for: .normal)
            })
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

extension UploadFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePickerController.dismiss(animated: true) {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.reactor?.action.onNext(.userSelectImage(originalImage))
            }
        }
    }
}
