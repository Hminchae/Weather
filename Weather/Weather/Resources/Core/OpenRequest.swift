//
//  OpenRequest.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation
import Alamofire

enum OpenRequest {
    case weatherWithID(id: Int)
    case hourlyWithID(id: Int)
    case weeklyWithID(id: Int)
    
    case weatherWithCoord(lat: Double, lon: Double)
    case hourlyWithCoord(lat: Double, lon: Double)
    case weeklyWithCoord(lat: Double, lon: Double)
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var endPoint: URL {
        switch self {
        case .weatherWithID, .weatherWithCoord:
            return URL(string: baseURL + "weather")!
        case .hourlyWithID, .hourlyWithCoord:
            return URL(string: baseURL + "forecast")!
        case .weeklyWithID, .weeklyWithCoord:
            return URL(string: baseURL + "forecast/daily?")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
        case .weatherWithID(let id), .hourlyWithID(let id), .weeklyWithID(let id):
            return ["id": id, "appid": Constants.API_KEY, "units": "metric"]
        case .weatherWithCoord(let lat, let lon), .hourlyWithCoord(let lat, let lon), .weeklyWithCoord(let lat, let lon):
            return ["lat": lat, "lon": lon, "appid": Constants.API_KEY, "units": "metric"]
        }
    }
}
