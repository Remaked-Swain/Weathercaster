//
//  MainView.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import SwiftUI
import MapKit

struct MainView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var mainVM = MainViewModel()
    
    @State private var annotationPlaces: [PlaceModel] = []
    
    var body: some View {
        ZStack {
            // Background
            Map(coordinateRegion: $mainVM.region, showsUserLocation: true, annotationItems: annotationPlaces) { place in
                MapMarker(coordinate: place.coordinates, tint: .theme.accentColor)
            }
                .ignoresSafeArea()

            // Interface Layer
            VStack {
                searchSection

                Spacer()

                if let weather = mainVM.weather {
                    WeatherView(weather: weather)
                        .environmentObject(mainVM)
                        .shadow(radius: 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager.shared)
    }
}
 
// MARK: Extracted Views
extension MainView {
    private var searchSection: some View {
        VStack {
            SearchBar(textFieldText: $mainVM.textFieldText)
                .onTapGesture {
                    // 검색창 조작 시 화면 확보를 위해 WeatherView 접기.
                    guard mainVM.showFullWeatherInfo else { return }
                    toggleWeatherView()
                }
            
            if mainVM.textFieldText.isEmpty == false {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(mainVM.searchResults) { place in
                            SearchListCell(place: place)
                                .padding()
                                .onTapGesture {
                                    pinMapMarker(to: place)
                                    moveCameraOnLocation(to: place)
                                }
                        }
                    }
                }
                .background(.thinMaterial)
                .cornerRadius(14)
            }
        }
        .shadow(radius: 10)
    }
}

// MARK: Methods
extension MainView {
    private func pinMapMarker(to place: PlaceModel) {
        annotationPlaces.removeAll()
        annotationPlaces.append(place)
    }
    
    private func moveCameraOnLocation(to place: PlaceModel) {
        withAnimation(.easeInOut) {
            mainVM.moveCameraOnLocation(to: place)
            mainVM.textFieldText.removeAll()
        }
    }
    
    private func toggleWeatherView() {
        withAnimation(.spring()) {
            mainVM.showFullWeatherInfo.toggle()
        }
    }
}
