//
//  HomeViewController.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit
import RxRelay

// TODO: 공통으로 쓸 수 있는 ViewController 만들기
class HomeViewController: UIViewController, StoryboardView {
    @IBOutlet weak var headerWrapper: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nowDateLabel: UILabel!
    @IBOutlet weak var nowTemperatureLabel: UILabel!
    @IBOutlet weak var lowestTemperatureLabel: UILabel!
    @IBOutlet weak var highestTemperatureLabel: UILabel!
    @IBOutlet weak var averageTemperatureLabel: UILabel!
    @IBOutlet weak var nowWeatherImageView: UIImageView!
    @IBOutlet weak var nowWeatherLabel: UILabel!
    @IBOutlet weak var nowWeatherAdditionalInfoImageView: UIImageView!
    @IBOutlet weak var nowWeatherAdditionalInfoLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var headerAddButton: UIButton!
    
    typealias Reactor = HomeReactor
    var disposeBag: DisposeBag = DisposeBag()
    lazy var selectPictureActionController: UIAlertController = {
        let alertController = UIAlertController.init(title: "사진 선택", message: "피드에 추가할 사진을 선택해주세요!", preferredStyle: .actionSheet)
        
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
    
    private let selectedImageRelay = PublishRelay<UIImage>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.reactor = HomeReactor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "icMenuFeedNormal"), selectedImage: UIImage(named: "icMenuFeedActive"))
        
        
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
    }
    
}

extension HomeViewController {
    func bind(reactor: HomeReactor) {
        headerAddButton.rx.tap
            .map { HomeReactor.Action.didTapHeaderAddFeedButton }
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
        
        selectedImageRelay
            .map { HomeReactor.Action.selectedPicture($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isSelectPicture }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in self?.showActionSheet() })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.tagViewController }
            .subscribe(onNext: { [weak self] tagViewController in
                guard let self = self,
                    let tagViewController = tagViewController else { return }
                self.present(tagViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.selectedImage }
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.showUploadFeedViewController(image: $0)
            })
            .disposed(by: disposeBag)
        
    }
}

extension HomeViewController {
    private func showActionSheet() {
        present(selectPictureActionController, animated: true, completion: nil)
    }
    
    private func showUploadFeedViewController(image: UIImage) {
        let viewController = UploadFeedViewController.newViewController(image: image)
    
        present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
    
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageRelay.accept(originalImage)
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

