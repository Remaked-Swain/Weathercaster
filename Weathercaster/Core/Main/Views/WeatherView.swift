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
        summaryWeatherInfo
        
        if mainVM.showFullWeatherInfo {
            fullWeatherInfo
                .transition(.push(from: .top))
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
                // Weather 지역명
                Text(weatherVM.weather.name ?? "-")
                    .font(.title.weight(.bold))
                // 기상상태 대표설명
                if let weatherList = weatherVM.weather.weather {
                    HStack {
                        ForEach(weatherList, id: \.id) {
                            Text($0.main ?? "")
                                .font(.caption)
                        }
                    }
                }
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
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                // 기상 상태
                if let weatherList = weatherVM.weather.weather {
                    Section {
                        HStack {
                            ForEach(weatherList, id: \.id) { weather in
                                Text(weather.description ?? "")
                                    .font(.headline)
                            }
                        }
                        .padding()
                    } header: {
                        FullWeatherInfoViewHeader(weatherType: .weatherList)
                    }
                }
                Divider()
                // 온도, 기압, 습도
                if let main = weatherVM.weather.main {
                    Section {
                        HStack {
                            VStack {
                                FullWeatherInfoMain(title: "평균 기온", value: main.temp ?? 0)
                                    .padding()
                                FullWeatherInfoMain(title: "체감 온도", value: main.feelsLike ?? 0)
                                    .padding()
                            }
                            
                            VStack {
                                FullWeatherInfoMain(title: "최저 온도", value: main.tempMin ?? 0)
                                    .padding()
                                FullWeatherInfoMain(title: "최대 온도", value: main.tempMax ?? 0)
                                    .padding()
                            }
                            
                            VStack {
                                FullWeatherInfoMain(title: "기압", value: main.feelsLike ?? 0)
                                    .padding()
                                FullWeatherInfoMain(title: "습도", value: main.feelsLike ?? 0)
                                    .padding()
                            }
                        }
                        .padding()
                    } header: {
                        HStack {
                            FullWeatherInfoViewHeader(weatherType: .main)
                        }
                    }
                }
                Divider()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .cornerRadius(14)
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
