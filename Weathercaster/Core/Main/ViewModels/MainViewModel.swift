//
//  MainViewModel.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import Foundation
import MapKit

@MainActor
class MainViewModel: ObservableObject {
    @Published var places: [PlaceModel] = []
    @Published var textFieldText: String = ""
    
    func searchAddress(text: String, region: MKCoordinateRegion) {
        // 검색 조건
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = region
        
        // 검색 조건 전달
        let search = MKLocalSearch(request: request)
        
        // 검색 수행
        search.start { response, error in
            guard let response = response else { print("검색 실패. \(error?.localizedDescription ?? "Unknown Error")"); return }
            self.places = response.mapItems.map(PlaceModel.init)
        }
    }
}
