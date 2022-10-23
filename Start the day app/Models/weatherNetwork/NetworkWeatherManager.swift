//
//  NetworkWeatherManager.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 30.06.2022.
//

import Foundation
import CoreLocation

final class NetworkWeatherManager {

    var onComplition: ((CurrentWeather) -> Void)?

    func fetchCurrentWeather(withLatitude latitude: CLLocationDegrees, withLongitude longitude: CLLocationDegrees ) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        requestWeather(withURLString: urlString)
    }

    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        requestWeather(withURLString: urlString)
    }

    private func requestWeather(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: url) { data, respone, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onComplition?(currentWeather)
                }
            }
        }
        task.resume()
    }

    private func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
