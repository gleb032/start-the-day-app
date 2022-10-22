//
//  ViewControlles+CLLocationManagerDelegate.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 21.10.2022.
//

import Foundation
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        networkWeatherManager.fetchCurrentWeather(withLatitude: lat, withLongitude: lon)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
