//
//  WeatherDataService.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import Foundation

class WeatherDataService {
    @Published var weather: WeatherModel? = nil
    
    init() {
        loadData()
    }
    
    func loadData() {
        
    }
}
