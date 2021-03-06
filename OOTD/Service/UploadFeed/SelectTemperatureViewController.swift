//
//  SelectTemperatureViewController.swift
//  OOTD
//
//  Created by HyeonTae Kim on 2020/09/11.
//  Copyright © 2020 fcs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class SelectTemperatureViewController: UIViewController, StoryboardBuildable, StoryboardView {
    @IBOutlet weak var weatherButtonsWrapperStackView: UIStackView!

    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var sliderBackgroundView: UIView!

    var disposeBag = DisposeBag()
    var isFirstLoaded: Bool = true
    weak var delegate: SelectTemparatureDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let weather = OOTD.shared.user.location.weather
        didTapSelectWeatherButton(at: weather.index)
        let temperature = OOTD.shared.user.preference.temperature.value
        temperatureSlider.value = Float(temperature)
        temparatureLabel.text = "\(temperature)°"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoaded {
            isFirstLoaded.toggle()
            let gradientLayer = CAGradientLayer()

            gradientLayer.colors = [UIColor(named: "red")!.cgColor, UIColor(named: "blue")!.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.locations = [0, 1]
            gradientLayer.frame = sliderBackgroundView.bounds
            sliderBackgroundView.clipsToBounds = true
            sliderBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    @IBAction func didTapWeatherCleanButton(_ sender: UIButton) {
        didTapSelectWeatherButton(at: 0)
        delegate?.didChangeWeather(.CLEAR)
    }

    @IBAction func didTapWeatherCloudButton(_ sender: UIButton) {
        didTapSelectWeatherButton(at: 1)
        delegate?.didChangeWeather(.CLOUDS)
    }

    @IBAction func didTapWeatherRainButton(_ sender: UIButton) {
        didTapSelectWeatherButton(at: 2)
        delegate?.didChangeWeather(.RAIN)
    }

    @IBAction func didTapWeatherSnowButton(_ sender: UIButton) {
        didTapSelectWeatherButton(at: 3)
        delegate?.didChangeWeather(.SNOW)
    }

    @IBAction func didTapWeatherThunderstormButton(_ sender: UIButton) {
        didTapSelectWeatherButton(at: 4)
        delegate?.didChangeWeather(.THUNDERSTORM)
    }

    // TODO: Text Color issue -> 왜 모든 텍스트의 컬러가 변경이 되는걸까?
    private func didTapSelectWeatherButton(at index: Int) {
        for (viewIndex, subView) in weatherButtonsWrapperStackView.arrangedSubviews.enumerated() {
            if viewIndex == index {
                subView.backgroundColor = UIColor(named: "skyBlue")
                (subView.subviews.first(where: { $0 is UILabel }) as? UILabel)?.textColor = UIColor(named: "grey6")
            } else {
                subView.backgroundColor = .white
                (subView.subviews.first(where: { $0 is UILabel }) as? UILabel)?.textColor = UIColor(named: "grey6")
            }
        }
    }

    @IBAction func temparatureValueChange(_ sender: UISlider) {
        temparatureLabel.text = String(Int(sender.value)) + "°"
        delegate?.didChangeTemparature(Int(sender.value))
    }
}

extension SelectTemperatureViewController {
    func bind(reactor: SelectTemperatureReactor) {
    }
}

protocol SelectTemparatureDelegate: AnyObject {
    func didChangeTemparature(_ temp: Int)
    func didChangeWeather(_ weather: FeedWeatherType)
}
