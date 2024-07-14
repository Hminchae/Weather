//
//  Date+Extension.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation

extension Date {
    func toHourString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH시"
        return dateFormatter.string(from: self)
    }
}
