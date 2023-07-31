//
//  MainViewModel.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import Foundation
import MapKit
import Combine

@MainActor
class MainViewModel: ObservableObject {
    // map
    @Published var region = MKCoordinateRegion()
    
    // weather
    @Published var weather: WeatherModel? = nil
    @Published var showFullWeatherInfo: Bool = false
    
    // Search by address or placemark name
    @Published var searchResults: [PlaceModel] = []
    @Published var textFieldText: String = ""
    
    // Services
    private let weatherDataService = WeatherDataService(coordinates: LocationManager.shared.region.center)
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        moveCameraOnLocation(to: nil)
        addSubscribers()
    }
    
    func addSubscribers() {
        // textFieldText의 변화가 있으면 0.5초 유예한 후 중복 요청을 제거, 마지막 검색 응답만 수신
        $textFieldText
            .filter { $0.isEmpty == false }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchAddress(text: searchText, region: LocationManager.shared.region)
            }
            .store(in: &cancellables)
        
        // weatherDataService 에서 유지하는 weather 에 변화가 감지되면 mainVM 의 weather 도 업데이트
        weatherDataService.$weather
            .sink { [weak self] receiveWeatherModel in
                self?.weather = receiveWeatherModel
            }
            .store(in: &cancellables)
    }
}

// MARK: LocationManager Methods
extension MainViewModel {
    private func searchAddress(text: String, region: MKCoordinateRegion) {
        // 검색 조건 설정
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = region
        
        // 검색 수행 객체 생성
        let search = MKLocalSearch(request: request)
        
        // 검색 수행하고 MapKit에서 응답받은 결과물을 저장
        search.start { response, error in
            guard let response = response else { print("검색 실패. \(error?.localizedDescription ?? "Unknown Error")"); return }
            self.searchResults = response.mapItems.map(PlaceModel.init)
        }
    }
    
    // 카메라를 특정 좌표로 이동하거나 nil이 들어오면 현재 사용자 위치로 이동, 바뀐 좌표의 날씨 정보로 업데이트
    func moveCameraOnLocation(to place: PlaceModel?) {
        guard let place = place else {
            self.region = LocationManager.shared.region
            fetchWeatherDataByPlace(coordinates: LocationManager.shared.region.center)
            return
        }
        
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        fetchWeatherDataByPlace(coordinates: place.coordinates)
    }
}

// MARK: OpenWeatherMap API Methods
extension MainViewModel {
    private func fetchWeatherDataByPlace(coordinates: CLLocationCoordinate2D) {
        weatherDataService.loadData(coordinates)
    }
}
