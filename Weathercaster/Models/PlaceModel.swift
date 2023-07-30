//
//  PlaceModel.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import Foundation
import MapKit

struct PlaceModel: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem)  {
        self.mapItem = mapItem
    }
    
    var name: String {
        return self.mapItem.name ?? "?"
    }
    
    var address: String {
        var cityAndState = ""
        var address = ""
        
        cityAndState = self.mapItem.placemark.locality ?? "" // 상위지명
        if let city = self.mapItem.placemark.administrativeArea {
            cityAndState = cityAndState.isEmpty ? city : "\(city), \(cityAndState)"
        }
        
        address = self.mapItem.placemark.subThoroughfare ?? "" // 하위주소
        if let street = self.mapItem.placemark.thoroughfare {
            address = address.isEmpty ? street : "\(street), \(address)"
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            // 하위주소가 없으면 도시만 트리밍
            address = cityAndState
        } else {
            // 도시가 없으면 하위주소만 트리밍
            address = cityAndState.isEmpty ? address : "\(cityAndState), \(address)"
        }
        
        return address
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
}
