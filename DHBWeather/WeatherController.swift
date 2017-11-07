//
//  WeatherController.swift
//  DHBWeather
//
//  Created by Daniel Salomon on 27.10.17.
//  Copyright © 2017 Daniel Salomon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class WeatherController {
    func loadWeather(city: String, callBack: @escaping (_ : WeatherData) -> Void ) {
   //     URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
        
        let url = "https://api.openweathermap.org/data/2.5/weather"
        var params = [
            "q" : "London",
            "appid" : "fca1a5491073266bed61f8025bc51110",
            "units" : "metric",
            "lang" : "de"
        ]
        params["q"] = city
        
        if NetworkReachabilityManager()!.isReachable {
            Alamofire.request(url, parameters: params).response{
                response in
                NSLog("NETWORK: Webrequest exited with response code \(response.response!.statusCode)!")
                
                if let data = response.data {
                    let json = JSON(data)
                    let resultingdata = WeatherData(temperature: "\(json["main"]["temp"].doubleValue)°C", weather: "\(json["weather"][0]["description"])", cityname: "\(json["name"])", weatherimage: "\(json["weather"][0]["icon"])")
                    NSLog("NETWORK: Temperature \(json["main"]["temp"])°C with weather '\(json["weather"][0]["description"])' and icon \(json["weather"][0]["icon"]) recieved for area '\(json["name"])'.")
                    callBack(resultingdata)
                } else {
                    NSLog("NETWORK: Couldnt recieve data...")
                }
            }
        } else {
            NSLog("NETWORK: No network connection available...")
            let resultingdata = WeatherData(temperature: "--°C", weather: "Fleischbällchenregen", cityname: city, weatherimage: "meatballs")
            callBack(resultingdata)
        }
        
        
    }
    
}
