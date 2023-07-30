//
//  FullWeatherInfoViewHeader.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import SwiftUI

struct FullWeatherInfoViewHeader: View {
    let weatherType: WeatherType
    
    var body: some View {
        HStack {
            Image(systemName: weatherType.imageName)
            Text(weatherType.title)
            Spacer()
        }
        .font(.headline)
        .foregroundColor(.secondary)
    }
}
