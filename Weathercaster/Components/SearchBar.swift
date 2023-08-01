//
//  SearchBar.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import SwiftUI

struct SearchBar: View {
    @FocusState private var textFieldFocused: Bool
    @Binding var textFieldText: String
    
    var body: some View {
        // SearchBar
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(textFieldText.isEmpty ? .secondary : .theme.accentColor)
            
            TextField("주소 검색", text: $textFieldText)
                .focused($textFieldFocused)
            
            if textFieldText.isEmpty == false {
                Button {
                    textFieldText.removeAll()
                    hideKeyboard()
                } label: {
                    Text("취소")
                }
            }
        }
        .font(.headline)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(14)
    }
    
    private func hideKeyboard() {
        withAnimation(.easeInOut) {
            textFieldFocused = false
        }
    }
}
