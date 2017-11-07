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
    
    var completionHandler: weatherModelCompletionHandler?
    
    var weatherController : WeatherController
    
    init() {
        weatherController = WeatherController()
        weatherModel = WeatherData()
    }
    
    
    func fetchWeatherDataForCity( city : String , ch : weatherModelCompletionHandler ) {
        
    }
    
    
    
}
