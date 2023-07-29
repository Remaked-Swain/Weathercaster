//
//  LocationRequestingView.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/29.
//

import SwiftUI

struct LocationRequestingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            imageSection
            
            appTitleSection
            
            descriptionSection
            
            Spacer()
            
            buttonsSection
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct LocationRequestingView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestingView()
    }
}

extension LocationRequestingView {
    private var imageSection: some View {
        Image(systemName: "paperplane.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .foregroundColor(.accentColor)
            .padding()
    }
    
    private var appTitleSection: some View {
        Text("Weather-Caster")
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
    
    private var descriptionSection: some View {
        Text("위치 정보를 기반으로 날씨 정보를 제공하기 위해 위치 정보가 필요합니다.")
            .font(.headline)
            .padding()
    }
    
    private var buttonsSection: some View {
        VStack {
            Button {
                LocationManager.shared.requestLocation()
            } label: {
                Text("위치 권한 켜기")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.theme.backgroundColor)
                    .background(Color.theme.accentColor)
                    .cornerRadius(14)
            }
            
            Button {
                // Maybe later
            } label: {
                Text("나중에 하기")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(14)
            }
        }
    }
}
