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
    @State private var showFullWeatherInfo: Bool = false
    
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

                weatherSection
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
    
    private var weatherSection: some View {
        VStack {
            // Summary Weather Info
            HStack {
                VStack(alignment: .leading) {
                    Text(mainVM.place?.name ?? "-")
                        .font(.title.weight(.bold))
                    
                    Text(mainVM.place?.address ?? "-")
                        .font(.caption)
                }
                
                Spacer()
                
                Button {
                    // splash full whether info
                } label: {
                    Image(systemName: showFullWeatherInfo ? "chevron.down" : "chevron.up")
                        .imageScale(.large)
                        .font(.headline)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .cornerRadius(14)
            
            // Full Weather Info
            VStack {
                
            }
        }
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
}
