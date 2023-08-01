//
//  WeatherView.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var mainVM: MainViewModel
    
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
        .background(.ultraThinMaterial)
        .cornerRadius(14)
    }
    
    private var fullWeatherInfo: some View {
        // Full Weather Info
        ScrollView {
            // weather
            LazyVStack(pinnedViews: .sectionHeaders) {
                Section {
                    weather
                } header: {
                    FullWeatherInfoViewHeader(imageName: "calendar", title: "기상 상태")
                }
            }.fullWeatherDataSectionModifier()
            
            // temperature
            HStack {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        feelsLike
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "thermometer", title: "체감 온도")
                    }
                }
                .fullWeatherDataSectionModifier()
                
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        tempMin
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "thermometer.low", title: "최저 온도")
                    }
                }
                .fullWeatherDataSectionModifier()
                
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        tempMax
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "thermometer.high", title: "최대 온도")
                    }
                }
                .fullWeatherDataSectionModifier()
            }
            .padding(.top)
            
            // pressure & humidity
            HStack {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        pressure
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "gauge.medium", title: "기압")
                    }
                }
                .fullWeatherDataSectionModifier()
                
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        humidity
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "humidity", title: "습도")
                    }
                }
                .fullWeatherDataSectionModifier()
            }
            .padding(.top)
            
            // visibility & clouds
            HStack {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        visibility
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "eye.fill", title: "가시거리")
                    }
                }
                .fullWeatherDataSectionModifier()
                
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        cloud
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "cloud.fill", title: "구름 양")
                    }
                }
                .fullWeatherDataSectionModifier()
            }
            .padding(.top)
            
            // wind
            HStack {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        wind
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "wind", title: "풍속")
                    }
                }
                .fullWeatherDataSectionModifier()
                
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        doc
                    } header: {
                        FullWeatherInfoViewHeader(imageName: "doc", title: "날씨 데이터 출처")
                    }
                }
                .fullWeatherDataSectionModifier()
            }
            .padding(.top)
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
                        .font(.title2)
                        .fontWeight(.heavy)
                    Text(weather.main ?? "-")
                }
            }
            
            Spacer()
            
            if let temp = mainVM.weather?.main?.temp {
                VStack(alignment: .leading) {
                    Text("기온")
                    Text(String(format: "%.2f°", temp))
                        .font(.title2)
                        .fontWeight(.bold)
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
    
    private var feelsLike: some View {
        HStack {
            if let feelsLike = mainVM.weather?.main?.feelsLike {
                Text(String(format: "%.2f°", feelsLike))
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var tempMin: some View {
        HStack {
            if let tempMin = mainVM.weather?.main?.tempMin {
                Text(String(format: "%.2f°", tempMin))
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var tempMax: some View {
        HStack {
            if let tempMax = mainVM.weather?.main?.tempMax {
                Text(String(format: "%.2f°", tempMax))
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var pressure: some View {
        HStack {
            if let pressure = mainVM.weather?.main?.pressure {
                Text(String(format: "%.f hPa", pressure))
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var humidity: some View {
        HStack {
            if let humidity = mainVM.weather?.main?.humidity {
                Text("\(humidity) %")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var visibility: some View {
        HStack {
            if let visibility = mainVM.weather?.visibility {
                Text("\(visibility) m")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var cloud: some View {
        HStack {
            if let cloud = mainVM.weather?.clouds?.all {
                Text("\(cloud) %")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var wind: some View {
        HStack {
            if let windSpeed = mainVM.weather?.wind?.speed {
                Text(String(format: "%.2f m/s", windSpeed))
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var doc: some View {
        HStack {
            if let url = URL(string: "https://openweathermap.org") {
                Link(destination: url) {
                    Text("OpenWeatherMap API")
                        .lineLimit(1)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
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
