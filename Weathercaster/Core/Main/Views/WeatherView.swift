//
//  WeatherView.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var mainVM: MainViewModel
    
    @Binding var showFullWeatherInfo: Bool
    
    var body: some View {
        VStack {
            summaryWeatherInfo
            
            if showFullWeatherInfo {
                fullWeatherInfo
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager.shared)
    }
}

// MARK: Extracted Views
extension WeatherView {
    private var summaryWeatherInfo: some View {
        // Summary Weather Info
        HStack {
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.title.weight(.bold))
                
                Text("description")
                    .font(.caption)
            }
            
            Spacer()
            
            Button {
                toggleWeatherView()
            } label: {
                Image(systemName: "chevron.down")
                    .rotationEffect(Angle(degrees: showFullWeatherInfo ? 180 : 360))
                    .imageScale(.large)
                    .font(.headline)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .cornerRadius(14)
    }
    
    private var fullWeatherInfo: some View {
        // Full Weather Info
        VStack {
            
        }
    }
}

// MARK: Methods
extension WeatherView {
    private func toggleWeatherView() {
        withAnimation(.spring()) {
            showFullWeatherInfo.toggle()
        }
    }
}
