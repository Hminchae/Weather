//
//  NetworkError.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation

enum NetworkError: Error {
    case failedRequest
    case noData
    case invalidResponsse
    case invalidData
}
