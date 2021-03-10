//
//  URLConstants.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 07/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import Foundation
class URLConstants {
    
    internal static func WeatherURLForCity(location: String)-> String
    {
        return "http://api.openweathermap.org/data/2.5/weather?q="+location+"&appid="+AppConstants.appToken+"&units=metric"
    }
    
    internal static func WeatherForeCastListURLForCoordinates(lat: String, long: String)-> String
    {
        return "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=fae7190d7e6433ec3a45285ffcf55c86&units=metric"
    }
}
