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
