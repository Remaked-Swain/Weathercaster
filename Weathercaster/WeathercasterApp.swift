//
//  WeathercasterApp.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/28.
//

import SwiftUI

@main
struct WeathercasterApp: App {
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(locationManager)
        }
    }
}
