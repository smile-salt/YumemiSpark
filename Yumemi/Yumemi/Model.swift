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

class WeatherDetail {
    
    var onWeatherError: ((String) -> ())?
    var onWeatherCondition: ((String) -> ())?
    var onMaxTemperature: ((Int) -> ())?
    var onMinTemperature: ((Int) -> ())?
    
    func setWeatherInfo() async{

            let sendJsonString = jsonString(area:"tokyo", date:"2020-04-01T12:00:00+09:00")
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(sendJsonString)
                guard let jsonValue = String(data: jsonData, encoding: .utf8) else {
                    return
                }
                
                let responseWeatherString = try await YumemiWeather.asyncFetchWeather(jsonValue)
                
                guard let jsonData = responseWeatherString.data(using: .utf8),
                      let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                      let maxTemperature = json["max_temperature"] as? Int,
                      let minTemperature = json["min_temperature"] as? Int,
                      let weatherCondition = json["weather_condition"] as? String
                else {
                    return
                }
                self.onWeatherCondition?(weatherCondition)
                self.onMaxTemperature?(maxTemperature)
                self.onMinTemperature?(minTemperature)
                
            } catch YumemiWeatherError.unknownError {
                self.onWeatherError?("エラー　a123456")
            } catch {
                self.onWeatherError?("エラー　c321654")
            }
        }

}
