//
//  ViewController.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 30.06.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let randomQuoteLabel = LabelFactory.makeLabel(text: "Hey", font: .italicSystemFont(ofSize: 25))
    private let weatherStackView = WeatherStackView()
    private let searchStackView = SearchStackView()
    private let weatherImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "no.internet.connection")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let networkWeatherManager = NetworkWeatherManager()
    private let networkQuoteManager = NetworkQuoteManager()
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestAlwaysAuthorization()
        return lm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background") ?? UIImage())
        // TODO: Rewrite
        searchStackView.searchButton.addTarget(
            self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside
        )

        setUpWeatherImageLayout()
        setUpWeatherStackViewLayout()
        setUpRandomeQuoteLayout()
        setUpSearchStackViewLayout()

        networkQuoteManager.onComplition = { [weak self] randomQuote in
            self?.updateInterfaceWith(randomQuote: randomQuote)
        }
        networkQuoteManager.fetchRandomQuote()

        networkWeatherManager.onComplition = { [weak self] currenWeather in
            self?.updateInterfaceWith(weather: currenWeather)
        }

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            networkWeatherManager.fetchCurrentWeather(
                forCity: randomCities.randomElement() ?? "Moscow"
            )
        }
    }

    @objc private func searchButtonTapped(_ sender: UIButton) {
        presentSearchAlertController(
            withTitle: "Enter city name",
            message: nil,
            style: .alert
        ) { [unowned self] cityName in
            self.networkWeatherManager.fetchCurrentWeather(forCity: cityName)
        }
    }
    
    private var viewHeight: CGFloat {
        view.frame.height
    }
    private var viewWidth: CGFloat {
        view.frame.width
    }
}

// MARK: UI set up

extension ViewController {
    private func setUpSearchStackViewLayout() {
        view.addSubview(searchStackView)

        searchStackView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20
        ).isActive = true
        searchStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20
        ).isActive = true
    }
    
    private func setUpRandomeQuoteLayout() {
        view.addSubview(randomQuoteLabel)
        
        randomQuoteLabel.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 30
        ).isActive = true
        randomQuoteLabel.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: -30
        ).isActive = true
        randomQuoteLabel.heightAnchor.constraint(
            lessThanOrEqualToConstant: viewHeight * 1/4
        ).isActive = true
        randomQuoteLabel.topAnchor.constraint(
            equalTo: weatherStackView.bottomAnchor, constant: 30
        ).isActive = true
    }

    private func setUpWeatherStackViewLayout() {
        view.addSubview(weatherStackView)

        weatherStackView.topAnchor.constraint(
            equalTo: weatherImage.bottomAnchor, constant: 5
        ).isActive = true
        weatherStackView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        weatherStackView.widthAnchor.constraint(
            equalTo: weatherImage.widthAnchor
        ).isActive = true
    }

    private func setUpWeatherImageLayout() {
        view.addSubview(weatherImage)

        weatherImage.widthAnchor.constraint(
            equalToConstant: viewWidth * 3 / 4
        ).isActive = true
        weatherImage.heightAnchor.constraint(
            equalTo: weatherImage.widthAnchor
        ).isActive = true
        weatherImage.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30
        ).isActive = true
        weatherImage.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
    }
}

// MARK: UI update

extension ViewController {
    private func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.searchStackView.updateUI(with: weather.cityName)
            self.weatherStackView.updateUI(with: weather)
            self.weatherImage.image = UIImage(
                systemName: weather.systemIconNameString
            )
        }
    }

    private func updateInterfaceWith(randomQuote: RandomQuote) {
        DispatchQueue.main.async {
            self.randomQuoteLabel.text = randomQuote.quote
        }
    }
}
