//
//  Model.swift
//  Yumemi
//
//  Created by school06 on 2024/01/18.
//

import Foundation
import YumemiWeather

protocol YumemiDelegate {
    func setWeatherImage(type: String)
}

class WeatherDetail {
    var delegate: YumemiDelegate?
    
    func setWeatherImage() {
        let responseWeatherString = YumemiWeather.fetchWeatherCondition()
        delegate?.setWeatherImage(type: responseWeatherString)
    }
}
