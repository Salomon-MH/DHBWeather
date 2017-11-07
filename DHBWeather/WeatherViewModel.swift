//
//  WeatherViewModel.swift
//  DHBWeather
//
//  Created by Daniel Salomon on 07.11.17.
//  Copyright © 2017 Daniel Salomon. All rights reserved.
//

import Foundation

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
            result in
            resultingdatastruct.cityname = result.cityname
            resultingdatastruct.weather = result.weather
            resultingdatastruct.temperature = result.temperature
            resultingdatastruct.weatherimage = result.weatherimage
            NSLog("INFO: Weather data loaded to WeatherData struct!")
            self.weatherDataConsumer?.receiveWeatherData(model: resultingdatastruct )
        }
        
    }
    
    
    
}
