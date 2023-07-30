//
//  WeatherViewModel.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import Foundation
import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    let weather: WeatherModel
    
    // Services
    private let imageDataService: ImageDataService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(weather: WeatherModel) {
        // weather 정보 내 iconCode을 전달하기 위해 우선 weather를 받아옴
        self.weather = weather
        self.imageDataService = ImageDataService(weather: weather)
        
        // ImageDataService의 image 게시자를 구독
        addSubscribers()
        
        // 이 과정은 이미지 로딩 과정이므로 true로 설정
        self.isLoading = true
    }
    
    private func addSubscribers() {
        imageDataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] receivedImage in
                self?.image = receivedImage
            }
            .store(in: &cancellables)
    }
}
