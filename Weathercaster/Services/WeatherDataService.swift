//
//  WeatherDataService.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

class WeatherDataService {
    @Published var weather: WeatherModel? = nil
    @Published var image: UIImage? = nil
    
    private var weatherSubscription: AnyCancellable?
    private var imageSubscription: AnyCancellable?
    
    private let openKey: String = "OPENWEATHERMAP_KEY"
    
    init(coordinates: CLLocationCoordinate2D) {
        loadData(coordinates)
    }
    
    func loadData(_ coordinates: CLLocationCoordinate2D) {
        // Read Bundle to get apiKey
        guard let apiKey: String = Bundle.getAPIKey(for: openKey) else { return }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)&units=metric&lang=kr") else { print("유효하지 않은 URL"); return }
        
        print("URL: \(url.description) 날씨 정보 요청")
        
        weatherSubscription = NetworkingManager.download(url: url)
        // Converting to WeatherModel
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
        // WeatherModel 수신 후 구독 취소
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] receivedWeatherModel in
                    self?.weather = receivedWeatherModel
                    self?.weatherSubscription?.cancel()
                    self?.getWeatherImage(receivedWeatherModel)
            })
    }
    
    private func getWeatherImage(_ weather: WeatherModel) {
        guard let iconCode = weather.weather?.first?.icon
        else { print("IconCode를 확인할 수 없음."); return }
        
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png") else { print("유효하지 않은 URL."); return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] receivedImage in
                    self?.image = receivedImage
                    self?.imageSubscription?.cancel()
                })
    }
}
