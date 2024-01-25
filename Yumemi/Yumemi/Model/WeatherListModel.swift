//
//  WeatherListModel.swift
//  Yumemi
//
//  Created by school06 on 2024/01/25.
//

import Foundation
import YumemiWeather

class WeatherDetailList {

    func setWeatherList() async -> Result<[AreaResponse], Error> {
        let date = Date().ISO8601Format()
        let requestString = AreaRequest(areas:[], date: date)

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(requestString)
            guard let jsonValue = String(data: jsonData, encoding: .utf8) else {
                return .failure(YumemiWeatherError.unknownError)
            }

            let responseString = try await YumemiWeather.asyncFetchWeatherList(jsonValue)
            guard let jsonData = responseString.data(using: .utf8) else {
                return .failure(YumemiWeatherError.unknownError)
            }

            let decoder = JSONDecoder()
            let response = try decoder.decode([AreaResponse].self, from: jsonData)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
