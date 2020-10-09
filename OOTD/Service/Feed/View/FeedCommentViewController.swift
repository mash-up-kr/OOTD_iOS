//
//  FeedCommentViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import ReactorKit

class FeedCommentViewController: UIViewController, StoryboardBuildable, StoryboardView {
    typealias Reactor = FeedCommentReactor

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentSendButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentTextFieldView: UIView!
    @IBOutlet weak var commentTextFieldViewBottomConstraint: NSLayoutConstraint!

    private var feed: Feed!
    private var comments: [FeedComment]!

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = FeedCommentReactor(feed: feed, comments: comments)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func bind(reactor: FeedCommentReactor) {
        commentTextField.rx.text
            .map { Reactor.Action.editComment($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.comments }
            .subscribe(onNext: {[weak self] comments in
                guard let self = self else { return }
                self.comments = comments
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isEditing }
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] isEditing in
                guard let self = self else { return }
                self.commentTextField.layer.borderColor = UIColor.blueKey.cgColor
                self.commentTextField.layer.borderWidth = isEditing ? 1 : 0
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.commentEdited }
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] comment in
                guard let self = self else { return }
                self.commentSendButton.isEnabled = !(comment?.isEmpty ?? true)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.commentCompleted }
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] comment in
                guard let self = self, let comment = comment else { return }
                self.reactor?.action.onNext(.setComment(message: comment, feed: self.feed))
            })
            .disposed(by: disposeBag)
    }

    @IBAction func actionUploadComment(_ sender: Any) {
        reactor?.action.onNext(.startUpload)
        commentTextField.text = nil
        commentTextField.resignFirstResponder()
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardInfo = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardInfo.cgRectValue.height
        let safeAreaInset = view.safeAreaInsets.bottom
        commentTextFieldViewBottomConstraint.constant = keyboardHeight - safeAreaInset
    }

    @objc private func keyboardWillHide(notification: Notification) {
        commentTextFieldViewBottomConstraint.constant = 0
    }

    static func instantiate(comments: [FeedComment], for feed: Feed) -> Self {
        let commentViewController = instantiate()
        commentViewController.feed = feed
        commentViewController.comments = comments
        return commentViewController
    }
}

extension FeedCommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCommentTableViewCell.reusableIdentifier, for: indexPath) as! FeedCommentTableViewCell
        cell.configure(comments[indexPath.item])
        return cell
    }
}

extension FeedCommentViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reactor?.action.onNext(.setEditing(true))
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        reactor?.action.onNext(.setEditing(false))
    }
}
