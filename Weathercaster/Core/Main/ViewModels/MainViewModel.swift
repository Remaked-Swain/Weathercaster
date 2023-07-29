//
//  MainViewModel.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import Foundation
import MapKit

final class MainViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.4872, longitude: 126.8334),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    func setUserLocation() {
        guard let coordinate2D = LocationManager.shared.userLocation?.coordinate else { return }
        print(coordinate2D)
        region = MKCoordinateRegion(center: coordinate2D, span: region.span)
    }
}
