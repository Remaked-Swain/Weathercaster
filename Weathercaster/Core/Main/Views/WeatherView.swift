//
//  WeatherView.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var mainVM: MainViewModel
    @StateObject private var weatherVM: WeatherViewModel
    
    init(weather: WeatherModel) {
        _weatherVM = StateObject(wrappedValue: WeatherViewModel(weather: weather))
    }
    
    var body: some View {
        VStack {
            summaryWeatherInfo
            
            if mainVM.showFullWeatherInfo {
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
            if let image = weatherVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else if weatherVM.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading) {
                Text(weatherVM.weather.name ?? "-")
                    .font(.title.weight(.bold))
                
                Text("")
                    .font(.caption)
            }
            
            Spacer()
            
            Button {
                toggleWeatherView()
            } label: {
                Image(systemName: "chevron.down")
                    .rotationEffect(Angle(degrees: mainVM.showFullWeatherInfo ? 180 : 360))
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
            mainVM.showFullWeatherInfo.toggle()
        }
    }
}
