//
//  ViewController.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 30.06.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let weatherImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let weatherStackView = WeatherStackView()
    private let searchStackView = SearchStackView()

    let networkWeatherManager = NetworkWeatherManager()
    let networkQuoteManager = NetworkQuoteManager()
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

        setUpSearchStackViewLayout()
        searchStackView.searchButton.addTarget(
            self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside
        )

        setUpWeatherImageUI()
        setUpWeatherStackViewLayout()

//        networkQuoteManager.onComplition = { [weak self] randomQuote in
//            self?.updateInterfaceWith(randomQuote: randomQuote)
//        }
//        networkQuoteManager.fetchRandomQuote()

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

    private func presentSearchAlertController(
        withTitle title: String?,
        message: String?,
        style: UIAlertController.Style,
        completionHandler: @escaping (String) -> Void) {

        let allertController = UIAlertController(title: title, message: message, preferredStyle: style)

        allertController.addTextField(configurationHandler: { textField in
            textField.placeholder = randomCities.randomElement()
        })

        let search = UIAlertAction(title: "Search", style: .default) { _ in
            let textField = allertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if !cityName.isEmpty {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        allertController.addAction(search)
        allertController.addAction(cancel)
        present(allertController, animated: true)
    }
}

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

    private func setUpWeatherStackViewLayout() {
        view.addSubview(weatherStackView)

        weatherStackView.topAnchor.constraint(
            equalTo: weatherImage.bottomAnchor, constant: 30
        ).isActive = true
        weatherStackView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
    }

    private func setUpWeatherImageUI() {
        view.addSubview(weatherImage)

        weatherImage.image = UIImage(named: "no.internet.connection")

        weatherImage.heightAnchor.constraint(
            equalToConstant: 250
        ).isActive = true
        weatherImage.widthAnchor.constraint(
            equalTo: weatherImage.heightAnchor
        ).isActive = true
        weatherImage.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30
        ).isActive = true
        weatherImage.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
    }
}

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

//    func updateInterfaceWith(randomQuote: RandomQuote) {
//        DispatchQueue.main.async {
//            self.quote.text = randomQuote.quote
//        }
//    }
}
