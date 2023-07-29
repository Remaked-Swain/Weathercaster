//
//  WeatherModel.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/28.
//

import Foundation

// OpenWeatherMap API
/*
 https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(api_key)&units=metric&lang=kr
 
 {
    "coord":{
       "lon":126.8334,
       "lat":37.4872
    },
    "weather":[
       {
          "id":801,
          "main":"Clouds",
          "description":"약간의 구름이 낀 하늘",
          "icon":"02d"
       }
    ],
    "base":"stations",
    "main":{
       "temp":32.49,
       "feels_like":37.6,
       "temp_min":28.78,
       "temp_max":33.8,
       "pressure":1014,
       "humidity":58
    },
    "visibility":10000,
    "wind":{
       "speed":5.66,
       "deg":280
    },
    "clouds":{
       "all":20
    },
    "dt":1690615036,
    "sys":{
       "type":1,
       "id":8105,
       "country":"KR",
       "sunrise":1690576412,
       "sunset":1690627473
    },
    "timezone":32400,
    "id":1948005,
    "name":"Kwangmyŏng",
    "cod":200
 }
 */

struct WeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

struct Coord: Codable {
    let lon, lat: Double?
}

struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}

struct Clouds: Codable {
    let all: Int?
}

struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}
