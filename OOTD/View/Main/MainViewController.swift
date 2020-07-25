//
//  HomeViewController.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/07/25.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(title: nil, image: <#T##UIImage?#>, selectedImage: <#T##UIImage?#>)
    }
    
}
