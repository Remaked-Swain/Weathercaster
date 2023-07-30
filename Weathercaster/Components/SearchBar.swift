//
//  SearchBar.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import SwiftUI

struct SearchBar: View {
    @Binding var textFieldText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(textFieldText.isEmpty ? .secondary : .theme.accentColor)
            
            TextField("주소 검색", text: $textFieldText)
            
            if textFieldText.isEmpty == false {
                Button {
                    textFieldText.removeAll()
                } label: {
                    Text("취소")
                }
            }
        }
        .font(.headline)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(14)
    }
}
