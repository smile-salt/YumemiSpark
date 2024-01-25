//
//  Model.swift
//  Yumemi
//
//  Created by school06 on 2024/01/18.
//

import Foundation
import YumemiWeather

class WeatherDetail {
    
    func setWeatherInfo() async -> Result<(String,Int,Int), Error> {
        let sendJsonString = jsonString(area:"tokyo", date:"2020-04-01T12:00:00+09:00")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(sendJsonString)
            guard let jsonValue = String(data: jsonData, encoding: .utf8) else {
                return (.failure(YumemiWeatherError.unknownError))
            }
            
            let responseWeatherString = try await YumemiWeather.asyncFetchWeather(jsonValue)
            
            guard let jsonData = responseWeatherString.data(using: .utf8) else {
                return (.failure(YumemiWeatherError.unknownError))
            }
            
            
            let decoder = JSONDecoder()
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)

            return (.success((weatherResponse.weather_condition,
                              weatherResponse.max_temperature,
                              weatherResponse.min_temperature)))
            
        } catch {
            return (.failure(error))
        }
        
    }
}
