//
//  FullWeatherInfoViewHeader.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import SwiftUI

struct FullWeatherInfoViewHeader: View {
    let imageName: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(title)
            Spacer()
        }
        .font(.headline)
        .foregroundColor(.secondary)
    }
}
