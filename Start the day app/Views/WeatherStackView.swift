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
    private let temperature = LabelFactory.makeLabel(alignment: .left)
    private let feelsLikeTemperature = LabelFactory.makeLabel(alignment: .left)

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 1
        addArrangedSubview(temperature)
        addArrangedSubview(feelsLikeTemperature)
    }

    func updateUI(with weather: TemperatureString) {
        temperature.text = "Temperature: " + weather.temperatureString + " °C"
        feelsLikeTemperature.text = "        Feels like " + weather.feelsLikeTemperatureString + " °C"
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
