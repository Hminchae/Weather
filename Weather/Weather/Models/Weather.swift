//
//  Weather.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation

struct OpenWeather: Decodable {
    let weather: [Weather]
    let main: MainInfo
    let wind: Wind
    let sys: Sys
    let id: Int
    let name: String
}

struct Sys: Decodable {
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Decodable {
    let main: String // ex) "Clear"
    let icon: String
    let id: Int
    let description: String
}

struct MainInfo: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
    }
}

struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
