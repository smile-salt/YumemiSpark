//
//  Area.swift
//  Yumemi
//
//  Created by school06 on 2024/01/25.
//

import Foundation
import YumemiWeather

struct AreaRequest: Codable {
    let areas: [String]
    let date: String
}

struct AreaResponse: Codable {
    let area: Area
    let info: WeatherResponse
}
