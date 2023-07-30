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
    
    var body: some View {
        ZStack {
            // Background
            Map(coordinateRegion: $mainVM.region, showsUserLocation: true)
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

extension MainView {
    private var searchSection: some View {
        VStack {
            SearchBar(textFieldText: $mainVM.textFieldText)
            
            if mainVM.textFieldText.isEmpty == false {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(mainVM.places) { place in
                            SearchListCell(place: place)
                                .padding()
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
            // Full Weather Info
            VStack {
                
            }
            
            // Summary Weather Info
            HStack {
                Text("Controls")
            }
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .cornerRadius(25)
        }
    }
}
