//
//  ViewModifier.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/31.
//

import Foundation
import SwiftUI

struct FullWeatherDataSectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(14)
    }
}

extension View {
    func fullWeatherDataSectionModifier() -> some View {
        self.modifier(FullWeatherDataSectionModifier())
    }
}
