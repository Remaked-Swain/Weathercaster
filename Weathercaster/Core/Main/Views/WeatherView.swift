//
//  WeatherView.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var mainVM: MainViewModel
    
    private let column: [GridItem] = [.init(.flexible()), .init(.flexible())]
    
    var body: some View {
        if mainVM.showFullWeatherInfo {
            fullWeatherInfo
        } else {
            summaryWeatherInfo
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
            // Weather IconImage
            if let image = mainVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .background(
                        Color.theme.backgroundColor.cornerRadius(14)
                    )
            } else if mainVM.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading) {
                // Weather 지역명
                Text(mainVM.weather?.name ?? "-")
                    .font(.title.weight(.bold))
                // 기상상태 대표설명
                if let weatherList = mainVM.weather?.weather {
                    HStack {
                        ForEach(weatherList, id: \.id) {
                            Text($0.main ?? "")
                                .font(.caption)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Image(systemName: "chevron.up")
                .imageScale(.large)
                .font(.headline)
                .foregroundColor(.theme.accentColor)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .cornerRadius(14)
    }
    
    private var fullWeatherInfo: some View {
        // Full Weather Info
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                Section {
                    weather
                } header: {
                    FullWeatherInfoViewHeader(imageName: "calendar", title: "기상 상태")
                }
            }
            .fullWeatherDataSectionModifier()
            
            LazyVGrid(columns: column, spacing: 0, pinnedViews: .sectionHeaders) {
                Section {
                    //
                } header: {
                    FullWeatherInfoViewHeader(imageName: "thermometer", title: "기온")
                }
            }
            .fullWeatherDataSectionModifier()
        }
    }
}

// MARK: FullWeatherDataInfo - Sections
extension WeatherView {
    private var weather: some View {
        HStack {
            if let image = mainVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .background(
                        Color.theme.backgroundColor.cornerRadius(14)
                    )
            } else if mainVM.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let weather = mainVM.weather?.weather?.first {
                VStack(alignment: .leading) {
                    Text(weather.description ?? "-")
                        .font(.title)
                        .fontWeight(.heavy)
                    Text(weather.main ?? "-")
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .imageScale(.large)
                .font(.headline)
                .foregroundColor(.theme.accentColor)
        }
        .onTapGesture {
            toggleWeatherView()
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
