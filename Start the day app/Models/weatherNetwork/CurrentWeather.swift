//
//  CurrentWeather.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 01.07.2022.
//

import Foundation


struct CurrentWeather: TemperatureString {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return "\(temperature.rounded())"
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return "\(feelsLikeTemperature.rounded())"
    }
    
    let id: Int
    var systemIconNameString: String {
        switch id {
            case 200...232:
                return "cloud.bolt.rain.fill"
            case 300...321:
                return "cloud.drizzle.fill"
            case 500...531:
                return "cloud.rain.fill"
            case 600...622:
                return "clouds.snow.fill"
            case 701...781:
                return "smoke.fill"
            case 800:
                return "sun.min.fill"
            case 801...804:
                return "cloud.fill"
            default:
                return "nosign"
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        id = currentWeatherData.weather.first!.id
    }
}
