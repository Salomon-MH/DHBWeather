//
//  Protocols.swift
//  DHBWeather
//
//  Created by Daniel Salomon on 07.11.17.
//  Copyright © 2017 Daniel Salomon. All rights reserved.
//

import Foundation

protocol WeatherDataProvider {
    func fetchWeatherDataForCity( city : String , ch : weatherModelCompletionHandler )
}

protocol WeatherDataConsumer {
    func receiveWeatherData( model : WeatherData )
}

struct WeatherData {
    
    init() {
        temperature = ""
        weather = ""
        cityname = ""
        weatherimage = ""
    }
    
    init( temperature : String , weather : String , cityname : String , weatherimage : String ) {
        self.temperature = temperature
        self.weather = weather
        self.cityname = cityname
        self.weatherimage = weatherimage
    }
    
    var temperature: String
    var weather: String
    var cityname: String
    var weatherimage: String
}
