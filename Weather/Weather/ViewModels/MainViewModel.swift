//
//  MainViewModel.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import Foundation

final class MainViewModel {
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
   
    var outputData: Observable<OpenWeather?> = Observable(nil)
    
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
        NetworkManager.shared.request(api: OpenRequest.weatherWithID(id: 1835847), model: OpenWeather.self) { weather, error in
            if let weather = weather {
                print(weather)
                self.outputData.value = weather
            } else if let error = error {
                print(error)
            }
        }
    }
}
