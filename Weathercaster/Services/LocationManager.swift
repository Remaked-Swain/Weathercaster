//
//  LocationManager.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocation?
    
    static let shared = LocationManager()
    
    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // 권한 상태가 변경되면 호출되어 적절한 응답이 가능
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied: print("위치 정보 권한이 설정되지 않음.")
        case .authorizedAlways, .authorizedWhenInUse: print("위치 정보 권한이 설정됨.")
        @unknown default: print("위치 정보 권한에 접근하는 중 알 수 없는 오류 발생.")
        }
    }
    
    // 위치 정보가 바뀌었을 때 LocationManager 에서 저장하고 있을 위치 정보도 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}
