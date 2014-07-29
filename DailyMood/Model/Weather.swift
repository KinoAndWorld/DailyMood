//
//  Weather.swift
//  DailyMood
//
//  Created by kino on 14-7-15.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

class Weather: NSObject {
    
    enum WeatherState:Int{
        case Sunny = 0, Cloudy, SunRain, SunSnow, Dark, Rain, Thunder, Night
        
        func getImageName()->String{
            return "Weather_\(self.toRaw()+1)"
        }
    }
    
    var weatherState:WeatherState? = WeatherState.Sunny{
        willSet{
            if newValue == nil { let newValue = WeatherState.Sunny}
        }
    }
    
    class func weatherByStateIndex(index:Int)->Weather{
        let weather = Weather()
        weather.weatherState = WeatherState.fromRaw(index)
        
        return weather
    }
   
}
