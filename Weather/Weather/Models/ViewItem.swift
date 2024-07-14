//
//  ViewItem.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation

struct BannerItem: Hashable {
    let location: String
    let temperature: Int
    let description: String
    let maxTemp: Int
    let minTemp: Int
}

struct HourlyItem: Hashable {
    let hour: String
    let icon: String
    let temp: Double
}

struct WeeklyItem: Hashable {
    let dayOfWeek: String
    let icon: String
    let maxTemp: Double
    let minTemp: Double
}

struct EtcInfoItem: Hashable {
    let title: String
    let content: String
}
