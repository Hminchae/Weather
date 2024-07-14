//
//  NetworkManager.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func getWeather(lat: Double, lon: Double, completionHandler: @escaping (OpenWeather) -> Void) {
        let url = Constants.fullURL
        let para: Parameters = [
            "lat": lat,
            "lon": lon,
            "appid": Constants.API_KEY,
            "units": "metric"
        ]
        
        AF.request(url, parameters: para).responseDecodable(of: OpenWeather.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
