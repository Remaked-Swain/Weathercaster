//
//  PreviewProvider.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

struct DeveloperPreview {
    static let instance = DeveloperPreview()
    
    private init() {}
    
    let weathers: [WeatherModel] = [
        WeatherModel(
            coord: Coord(lon: 126.8334, lat: 37.4872),
            weather: [
                Weather(id: 801, main: "Clouds", description: "약간의 구름이 낀 하늘", icon: "02d")
            ],
            base: "stations",
            main: Main(temp: 32.49, feelsLike: 37.6, tempMin: 28.78, tempMax: 33.8, pressure: 1014, humidity: 58),
            visibility: 10000,
            wind: Wind(speed: 5.66, deg: 280),
            clouds: Clouds(all: 20),
            dt: 1690615036,
            sys: Sys(type: 1, id: 8105, country: "KR", sunrise: 1690576412, sunset: 1690627473),
            timezone: 32400,
            id: 1948005,
            name: "Kwangmyŏng",
            cod: 200
        ),
        
        WeatherModel(
            coord: Coord(lon: 120.9900, lat: 14.5700),
            weather: [
                Weather(id: 800, main: "Clear", description: "맑음", icon: "01d")
            ],
            base: "stations",
            main: Main(temp: 28.38, feelsLike: 30.57, tempMin: 27.78, tempMax: 29.44, pressure: 1011, humidity: 74),
            visibility: 10000,
            wind: Wind(speed: 4.63, deg: 80),
            clouds: Clouds(all: 0),
            dt: 1690615323,
            sys: Sys(type: 1, id: 8135, country: "PH", sunrise: 1690572730, sunset: 1690616786),
            timezone: 28800,
            id: 1717512,
            name: "Manila",
            cod: 200
        )
    ]
}
