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
    
    var body: some View {
        if LocationManager.shared.userLocation == nil {
            LocationRequestingView()
        } else {
            ZStack {
                // Background
                Map(coordinateRegion: $mainVM.region, showsUserLocation: true)
                    .ignoresSafeArea()

                // Interface Layer
                VStack {
                    // SearchBar
                    Text("SearchBar here")

                    Spacer()

                    // Controls
                    HStack {
                        Text("Controls")
                    }
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .cornerRadius(25)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            .onAppear {
                mainVM.setUserLocation()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
