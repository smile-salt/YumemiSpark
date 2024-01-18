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
    func setWeatherError(alert: String)
}

class WeatherDetail {
    var delegate: YumemiDelegate?
    
    func setWeatherImage() {
        do {
            let responseWeatherString = try YumemiWeather.fetchWeatherCondition(at: "")
            delegate?.setWeatherImage(type: responseWeatherString)
        } catch YumemiWeatherError.unknownError {
            delegate?.setWeatherError(alert: "エラー　a123456")
        } catch {
            delegate?.setWeatherError(alert: "エラー　c321654")
        }
    }
}
