//
//  ViewController.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 30.06.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private var weatherImage = UIImage()
    private let weatherStackView = WeatherStackView()
    private let searchStackView = SearchStackView()
    
//    @IBOutlet weak var quote: UILabel!
//    @IBOutlet weak var cityName: UILabel!
//    @IBOutlet weak var searchCityButton: UIButton!
    
    var networkWeatherManager = NetworkWeatherManager()
    var networkQuoteManager = NetworkQuoteManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestAlwaysAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.largeContentImage = UIImage(named: "background")
        setUpSearchStackViewUI()
        searchStackView.searchButton.addTarget(
            self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside
        )
        
//        networkQuoteManager.onComplition = { [weak self] randomQuote in
//            self?.updateInterfaceWith(randomQuote: randomQuote)
//        }
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
    
    private func presentSearchAlertController(
        withTitle title: String?,
        message: String?,
        style: UIAlertController.Style,
        completionHandler: @escaping (String) -> Void)
    {
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        allertController.addTextField(configurationHandler: { textField in
            textField.placeholder = randomCities.randomElement()
        })
        
        let search = UIAlertAction(title: "Search", style: .default) { action in
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
    private func setUpSearchStackViewUI() {
        view.addSubview(searchStackView)
        
        searchStackView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10
        ).isActive = true
        searchStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10
        ).isActive = true
    }
}


extension ViewController {
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.searchStackView.updateUI(with: weather.cityName)
            self.weatherStackView.updateUI(with: weather)
            self.weatherImage = UIImage(systemName: weather.systemIconNameString)
                ?? UIImage()
        }
    }
    
//    func updateInterfaceWith(randomQuote: RandomQuote) {
//        DispatchQueue.main.async {
//            self.quote.text = randomQuote.quote
//        }
//    }
}


