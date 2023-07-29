//
//  WeatherView.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import SwiftUI
import MapKit

struct WeatherView: View {
    @StateObject private var weatherVM = WeatherViewModel()
    
    var body: some View {
        ZStack {
            Map
            
            VStack {
                Text(weatherVM.weather?.name ?? "no")
                    .font(.largeTitle)
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
