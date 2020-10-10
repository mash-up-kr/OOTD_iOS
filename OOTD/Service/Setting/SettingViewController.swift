//
//  SettingViewController.swift
//  OOTD
//
//  Created by Hochan Lee on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa

final class SettingViewController: UIViewController, StoryboardBuildable, StoryboardView {
    static func newViewController() -> UIViewController {
        let settingViewController = SettingViewController.instantiate()
        let reactor = SettingReactor()
        settingViewController.reactor = reactor

        return UINavigationController(rootViewController: settingViewController)
    }

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView!

    private var userName = OOTD.shared.user.name
    private var styles = OOTD.shared.styles

    private var selectedStyles: [Style] {
        collectionView.indexPathsForSelectedItems?.map { styles[$0.item] } ?? []
    }

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self

        return picker
    }()

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        reactor = SettingReactor()

        nicknameTextField.text = userName
        setCollectionView()
        setNavigationBar()
    }

    @IBAction func changeImageAction(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectAction = UIAlertAction(title: "라이브러리에서 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        let deleteAction = UIAlertAction(title: "현재사진 삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.reactor?.action.onNext(.updateProfileImage(nil))
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        actionSheet.addAction(selectAction)
        if reactor?.currentState.profileImage != nil {
            actionSheet.addAction(deleteAction)
        }
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }
}

extension SettingViewController {
    private func setCollectionView() {
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self

        let selectedStyles = styles.enumerated().compactMap { OOTD.shared.user.preference.styles.contains($0.element) ? $0 : nil }
        selectedStyles.forEach { collectionView.selectItem(at: IndexPath(item: $0.offset, section: .zero), animated: false, scrollPosition: .top) }
    }

    private func setNavigationBar() {
        guard let bar = navigationController?.navigationBar else { return }
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
}

extension SettingViewController {
    func bind(reactor: SettingReactor) {
        reactor.state.map { $0.profileImage }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if $0 == nil {
                    self.profileImageView.image = UIImage(named: "icProfileEdit")
                    self.profileImageView.clipsToBounds = false
                } else {
                    self.profileImageView.image = $0
                    self.profileImageView.clipsToBounds = true
                    self.profileImageView.layer.cornerRadius = 48
                }
            })
            .disposed(by: disposeBag)

        nicknameTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        OOTD.shared.stylesPublishSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] styles in
                guard let self = self else { return }

                let selectedStyles = self.styles.enumerated().compactMap { styles.contains($0.element) ? $0 : nil }
                selectedStyles.forEach { self.collectionView.selectItem(at: IndexPath(item: $0.offset, section: .zero), animated: false, scrollPosition: .top) }
            })
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        styles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleCollectionViewCell.reusableIdentifier, for: indexPath) as! StyleCollectionViewCell
        cell.configure(styles[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.setSelectedStyles(selectedStyles))
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.setSelectedStyles(selectedStyles))
    }
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            reactor?.action.onNext(.updateProfileImage(originalImage))
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
