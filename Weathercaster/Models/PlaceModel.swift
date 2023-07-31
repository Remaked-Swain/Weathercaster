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
        
        // 상위 지명(시, 구 등)
        cityAndState = self.mapItem.placemark.locality ?? ""
        if let city = self.mapItem.placemark.administrativeArea {
            cityAndState = cityAndState.isEmpty ? city : "\(city), \(cityAndState)"
        }
        
        // 하위 지명(동, 도로명 혹은 지번)
        address = self.mapItem.placemark.subThoroughfare ?? ""
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
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: self.mapItem.placemark.coordinate.latitude,
            longitude: self.mapItem.placemark.coordinate.longitude
        )
    }
}
