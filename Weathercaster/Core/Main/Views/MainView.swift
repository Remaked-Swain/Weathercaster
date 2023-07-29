//
//  MainView.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import SwiftUI
import MapKit

struct MainView: View {
    @StateObject private var mainVM = MainViewModel()
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        ZStack {
            if locationManager.userLocation == nil {
                LocationRequestingView()
            } else if let location = locationManager.userLocation {
                Text("\(location)")
//                // Background
//                Map(coordinateRegion: $mainVM.region, showsUserLocation: true)
//                    .ignoresSafeArea()
//
//                // Interface Layer
//                VStack {
//                    // SearchBar
//                    Text("SearchBar here")
//
//                    Spacer()
//
//                    // Controls
//                    HStack {
//                        Text("Controls")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .background(.thinMaterial)
//                    .cornerRadius(25)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
