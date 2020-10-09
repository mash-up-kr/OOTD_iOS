//
//  SelectDateCollectionViewCell.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/10/03.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class SelectDateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let selectedBackgroundView = UIView(frame: bounds)
        let selectedBackgroundColorView = UIView()
        selectedBackgroundView.addSubview(selectedBackgroundColorView)
        selectedBackgroundColorView.centerXAnchor.constraint(equalTo: selectedBackgroundView.centerXAnchor).isActive = true
        selectedBackgroundColorView.centerYAnchor.constraint(equalTo: selectedBackgroundView.centerYAnchor).isActive = true
        selectedBackgroundColorView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        selectedBackgroundColorView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        selectedBackgroundColorView.translatesAutoresizingMaskIntoConstraints = false
        selectedBackgroundColorView.layer.cornerRadius = 15.0
        selectedBackgroundColorView.backgroundColor = UIColor(named: "blueKey")
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
    }

    func setDate(_ dateText: String) {
        dateLabel.text = dateText
    }
}
