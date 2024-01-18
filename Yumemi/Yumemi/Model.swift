//
//  Model.swift
//  Yumemi
//
//  Created by school06 on 2024/01/18.
//

import Foundation
import YumemiWeather

struct jsonString: Codable {
    let area: String
    let date: String
}

protocol YumemiDelegate {
    func setWeatherError(alert: String)
    func setWeatherCondition(type: String)
    func setMaxTemperature(max: Int)
    func setMinTemperature(max: Int)
}

class WeatherDetail {
    var delegate: YumemiDelegate?
    
    func setWeatherInfo() {
        DispatchQueue.global().async{
            let sendJsonString = jsonString(area:"tokyo", date:"2020-04-01T12:00:00+09:00")
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(sendJsonString)
                guard let jsonValue = String(data: jsonData, encoding: .utf8) else {
                    return
                }
                
                let responseWeatherString = try YumemiWeather.syncFetchWeather(jsonValue)
                
                guard let jsonData = responseWeatherString.data(using: .utf8),
                      let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                      let maxTemperature = json["max_temperature"] as? Int,
                      let minTemperature = json["min_temperature"] as? Int,
                      let weatherCondition = json["weather_condition"] as? String
                else {
                    return
                }
                self.delegate?.setWeatherCondition(type: weatherCondition)
                self.delegate?.setMaxTemperature(max: maxTemperature)
                self.delegate?.setMinTemperature(max: minTemperature)
                
            } catch YumemiWeatherError.unknownError {
                self.delegate?.setWeatherError(alert: "エラー　a123456")
            } catch {
                self.delegate?.setWeatherError(alert: "エラー　c321654")
            }
        }
    }
}
