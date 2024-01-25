//
//  Weather.swift
//  Yumemi
//
//  Created by school06 on 2024/01/25.
//

import Foundation

struct jsonString: Codable {
    let area: String
    let date: String
}

struct WeatherResponse: Codable {
    let weather_condition: String
    let max_temperature: Int
    let min_temperature: Int
}
