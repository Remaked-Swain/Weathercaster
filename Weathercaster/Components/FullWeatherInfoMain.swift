//
//  FullWeatherInfoMain.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import SwiftUI

struct FullWeatherInfoMain: View {
    let title: String
    let value: Double
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(String(format: "%.2f", value))
        }
    }
}
