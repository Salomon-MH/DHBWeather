//
//  WeatherViewModel.swift
//  DHBWeather
//
//  Created by Daniel Salomon on 07.11.17.
//  Copyright © 2017 Daniel Salomon. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire //Required for check if network is available, because no callback is followed then.

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
        let weatherControllerObj = WeatherController()
        var resultingdatastruct = WeatherData()
        
        weatherControllerObj.loadWeather(city: city) {
            response in
            if let data = response.data {
                let json = JSON(data)
                let resultingdata = WeatherData(temperature: "\(json["main"]["temp"].doubleValue)°C", weather: "\(json["weather"][0]["description"])", cityname: "\(json["name"])", weatherimage: "\(json["weather"][0]["icon"])")
                NSLog("NETWORK: Temperature \(json["main"]["temp"])°C with weather '\(json["weather"][0]["description"])' and icon \(json["weather"][0]["icon"]) recieved for area '\(json["name"])'.")
                NSLog("INFO: Weather data loaded to WeatherData struct!")
                self.weatherDataConsumer?.receiveWeatherData(model: resultingdata )
            } else {
                NSLog("NETWORK: Couldnt recieve data...")
                let resultingdata = WeatherData(temperature: "--°C", weather: "Fleischbällchenregen", cityname: city, weatherimage: "meatballs")
                self.weatherDataConsumer?.receiveWeatherData(model: resultingdata )
            }
            
            if !NetworkReachabilityManager()!.isReachable {
                let resultingdata = WeatherData(temperature: "--°C", weather: "Fleischbällchenregen", cityname: city, weatherimage: "meatballs")
                self.weatherDataConsumer?.receiveWeatherData(model: resultingdata )
            }
        }
    }
    
    
    
}
