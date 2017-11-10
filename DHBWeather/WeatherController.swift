//
//  WeatherController.swift
//  DHBWeather
//
//  Created by Daniel Salomon on 27.10.17.
//  Copyright © 2017 Daniel Salomon. All rights reserved.
//

import Foundation
import Alamofire


class WeatherController {
     func loadWeather(city: String, callBack: @escaping (_ : DefaultDataResponse?) -> Void ) {
        
        
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
                
                callBack(response)
            }
        } else {
            NSLog("NETWORK: No network connection available...")
            callBack(nil)
        }
        
        
    }
    
}
