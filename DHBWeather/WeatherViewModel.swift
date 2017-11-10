//
//  WeatherViewModel.swift
//  DHBWeather
//
//  Created by Daniel Salomon on 07.11.17.
//  Copyright © 2017 Daniel Salomon. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias weatherModelCompletionHandler = ( _ model : WeatherData ) -> Void

class WeatherViewModel : WeatherDataProvider {
    
    var weatherModel : WeatherData
    
    var weatherDataConsumer : WeatherDataConsumer?
    
    var completionHandler: weatherModelCompletionHandler?
    
    var weatherController : WeatherController
    
    init() {
        weatherController = WeatherController()
        weatherModel = WeatherData()
    }
    
    
    func fetchWeatherDataForCity( city : String ) {
        weatherController.loadWeather(city: city) {
            response in
            if let data = response?.data {
                let json = JSON(data)
                self.weatherModel = WeatherData(temperature: "\(json["main"]["temp"].doubleValue)°C", weather: "\(json["weather"][0]["description"])", cityname: "\(json["name"])", weatherimage: "\(json["weather"][0]["icon"])")
                NSLog("NETWORK: Temperature \(json["main"]["temp"])°C with weather '\(json["weather"][0]["description"])' and icon \(json["weather"][0]["icon"]) recieved for area '\(json["name"])'.")
                NSLog("INFO: Weather data loaded to WeatherData struct!")
                self.weatherDataConsumer?.receiveWeatherData(model: self.weatherModel )
            } else {
                NSLog("NETWORK: Couldnt recieve data...")
                self.weatherModel = WeatherData(temperature: "--°C", weather: "Fleischbällchenregen", cityname: city, weatherimage: "meatballs")
                self.weatherDataConsumer?.receiveWeatherData(model: self.weatherModel )
            }
        }
    }
    
    
    
}
