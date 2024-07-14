//
//  Forecast.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation

struct Forecast: Decodable {
    let cod: String
    let list: [ForecastItem]
    let city: City
}

struct City: Decodable {
    let id: Int // id
    let name: String // 도시 이름
    let coord: Coord // 위경도
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct Coord: Decodable {
    let lat, lon: Double
}

struct ForecastItem: Decodable {
    let dt: String
    let main: MainInfo
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt = "dt_txt"
        case main
        case weather
        case wind
        case visibility
        case rain
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(String.self, forKey: .dt).toHourString()
        self.dt = date.toHourString() // 00시
        self.main = try container.decode(MainInfo.self, forKey: .main)
        self.weather = try container.decode([Weather].self, forKey: .weather)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.visibility = try container.decode(Int.self, forKey: .visibility)
        self.rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
    }
}
