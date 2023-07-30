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
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .ignoresSafeArea()

            // Interface Layer
            VStack {
                searchSection

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
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager())
    }
}

extension MainView {
    private var searchSection: some View {
        VStack {
            SearchBar(textFieldText: $mainVM.textFieldText)
            
            if mainVM.textFieldText.isEmpty == false {
                List(mainVM.places) { place in
                    VStack(alignment:. leading) {
                        Text(place.name)
                            .font(.headline)
                        Text(place.address)
                            .font(.callout)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $mainVM.textFieldText)
                .onChange(of: mainVM.textFieldText, perform: { text in
                    if text.isEmpty == false {
                        mainVM.searchAddress(text: text, region: locationManager.region)
                    } else {
                        mainVM.places = []
                    }
                })
                .background(.thinMaterial)
                .cornerRadius(14)
            }
        }
        .shadow(radius: 10)
    }
}
