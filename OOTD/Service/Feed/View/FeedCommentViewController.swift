//
//  FeedCommentViewController.swift
//  OOTD
//
//  Created by pony.tail on 2020/10/09.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class FeedCommentViewController: UIViewController, StoryboardBuildable {
    private var comments = FeedComment.samples

    override func viewDidLoad() {
        super.viewDidLoad()
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
