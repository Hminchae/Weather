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
    
    func request<T: Decodable>(api: OpenRequest, 
                               model: T.Type, 
                               completionHandler: @escaping (T?, Error?) -> Void
    ) {
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<500)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}
