//
//  ImageDataService.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import Foundation
import SwiftUI
import Combine

class ImageDataService {
    @Published var image: UIImage? = nil
    
    private let weather: WeatherModel
    private var imageSubscription: AnyCancellable?
    
    init(weather: WeatherModel) {
        self.weather = weather
        getWeatherImage()
    }
    
    private func getWeatherImage() {
        guard self.weather.weather?.isEmpty == false,
              let iconCode = self.weather.weather?.first?.icon
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
