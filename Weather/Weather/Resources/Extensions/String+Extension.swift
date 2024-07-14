//
//  String+Extension.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation

extension String {
    func toHourString() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = inputFormatter.date(from: self) else {
            return "00시"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH시"
        
        return outputFormatter.string(from: date)
    }
}
