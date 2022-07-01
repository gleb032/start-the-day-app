//
//  ViewController.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 30.06.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var feelsLikeTemperature: UILabel!
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var searchCityButton: UIButton!
    
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
        searchCityButton.layer.cornerRadius = 15
        
        networkQuoteManager.onComplition = { [weak self] randomQuote in
            self?.updateInterfaceWith(randomQuote: randomQuote)
        }
        networkQuoteManager.fetchRandomQuote()
        
        networkWeatherManager.onComplition = { [weak self] currenWeather in
            self?.updateInterfaceWith(weather: currenWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            
        }
        
        networkWeatherManager.fetchCurrentWeather(forCity: "Moscow") 
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] cityName in
            self.networkWeatherManager.fetchCurrentWeather(forCity: cityName) 
        }
    }
    
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        allertController.addTextField(configurationHandler: { textField in
            textField.placeholder = randomCities.randomElement() // randomCities from Constants
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

// MARK: - Updating Interface

extension ViewController {
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityName.text = weather.cityName + "  "
            self.temperature.text = weather.temperatureString + " °C"
            self.feelsLikeTemperature.text = "feels like " + weather.feelsLikeTemperatureString + " °C";
            self.weatherImage.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
    func updateInterfaceWith(randomQuote: RandomQuote) {
        DispatchQueue.main.async {
            self.quote.text = randomQuote.quote
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(withLatitude: lat, withLongitude: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

