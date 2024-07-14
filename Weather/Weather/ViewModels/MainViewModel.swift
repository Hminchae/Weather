//
//  MainViewModel.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation

final class MainViewModel {
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    var outputWeatherData: Observable<OpenWeather?> = Observable(nil)
    var outputHourlyData: Observable<Forecast?> = Observable(nil)
    var outputWeeklyData: Observable<Forecast?> = Observable(nil)
    
    var outputNetworkRequestCompleted: Observable<Void?> = Observable(nil)
    
    init() {
        print("MainViewModel init")
        transform()
    }
    
    func transform() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            print("네트워크 통신 진행")
            self?.callRequest()
        }
    }
    
    private func callRequest() {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async(group: group) { [weak self] in
            NetworkManager.shared.request(api: OpenRequest.weatherWithID(id: 1835847), model: OpenWeather.self) { weather, error in
                defer { group.leave() }
                if let weather = weather {
                    print(weather)
                    self?.outputWeatherData.value = weather
                } else if let error = error {
                    print(error)
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) { [weak self] in
            NetworkManager.shared.request(api: OpenRequest.hourlyWithID(id: 1835847), model: Forecast.self) { weather, error in
                defer { group.leave() }
                if let weather = weather {
                    print(weather)
                    self?.outputHourlyData.value = weather
                } else if let error = error {
                    print(error)
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) { [weak self] in
            NetworkManager.shared.request(api: OpenRequest.weeklyWithID(id: 1835847), model: Forecast.self) { weather, error in
                defer { group.leave() }
                if let weather = weather {
                    print(weather)
                    self?.outputWeeklyData.value = weather
                } else if let error = error {
                    print(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.outputNetworkRequestCompleted.value = ()
        }
    }
}
