//
//  WeatherDataService.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import Foundation
import CoreLocation
import Combine

class WeatherDataService {
    @Published var weather: WeatherModel? = nil
    
    var weatherSubscription: AnyCancellable?
    
    private let openKey: String = "OPENWEATHERMAP_KEY"
    
    init(coordinates: CLLocationCoordinate2D) {
        loadData(coordinates)
    }
    
    private func loadData(_ coordinates: CLLocationCoordinate2D) {
        // Read Bundle to get apiKey
        guard let apiKey: String = Bundle.getAPIKey(for: openKey) else { return }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)&units=metric&lang=kr") else { print("유효하지 않은 URL"); return }
        
        weatherSubscription = URLSession.shared.dataTaskPublisher(for: url)
        // Working on DispatchQueue.global
        // 서버 응답 체크
            .tryMap { output in
                guard
                    let response = output.response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300
                else { throw URLError(.badServerResponse) }
                
                return output.data
            }
        // Working on DispatchQueue.main
            .receive(on: DispatchQueue.main)
        // Converting to WeatherModel
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
        // WeatherModel 수신 후 구독 취소
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error): print("Completion Error: \(error)")
                }
            }, receiveValue: { [weak self] receivedWeatherModel in
                self?.weather = receivedWeatherModel
                self?.weatherSubscription?.cancel()
            })
    }
}
