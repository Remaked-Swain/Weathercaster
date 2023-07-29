//
//  WeatherViewModel.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherModel? = nil
    
    private let openKey: String = "OPENWEATHERMAP_KEY"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        loadData()
    }
}

// MARK: Weather Data Service Methods
extension WeatherViewModel {
//    private func loadData() {
//        guard let apiKey: String = Bundle.getAPIKey(for: openKey) else { return }
//        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(region.center.latitude)&lon=\(region.center.longitude)&appid=\(apiKey)&units=metric&lang=kr") else { return }
//
//        URLSession.shared.dataTaskPublisher(for: url)
//            .receive(on: DispatchQueue.main)
//            .tryMap { output in
//                guard
//                    let response = output.response as? HTTPURLResponse,
//                    response.statusCode >= 200 && response.statusCode < 300 else {
//                    throw URLError(.badServerResponse)
//                }
//
//                return output.data
//            }
//            .decode(type: WeatherModel.self, decoder: JSONDecoder())
//            .sink { completion in
//                switch completion {
//                case .finished: break
//                case .failure(let error): print("디코딩 실패: \(error)")
//                }
//            } receiveValue: { [weak self] returnedWeatherModel in
//                self?.weather = returnedWeatherModel
//            }
//            .store(in: &cancellables)
//    }
}
