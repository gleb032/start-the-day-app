//
//  WeatherStackView.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 21.10.2022.
//

import UIKit

protocol TemperatureString {
    var temperatureString: String { get }
    var feelsLikeTemperatureString: String { get }
}

final class WeatherStackView: UIStackView {
    private var temperature: UILabel = {
        let label = UILabel()
        label.text = "Tralala"
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    private var feelsLikeTemperature: UILabel = {
        let label = UILabel()
        label.text = "Hey"
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 10
        addArrangedSubview(temperature)
        addArrangedSubview(feelsLikeTemperature)
    }
    
//    init(weather: TemperatureString) {
//        super.init(frame: .zero)
//        translatesAutoresizingMaskIntoConstraints = false
//        axis = .vertical
//        spacing = 10
//        addArrangedSubview(temperature)
//        addArrangedSubview(feelsLikeTemperature)
//        updateUI(with: weather)
//    }

    func updateUI(with weather: TemperatureString) {
        temperature.text = weather.temperatureString + " °C"
        feelsLikeTemperature.text = "Feels like " + weather.feelsLikeTemperatureString + " °C"
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

