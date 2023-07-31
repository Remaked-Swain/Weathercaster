//
//  SearchListCell.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import SwiftUI

struct SearchListCell: View {
    let place: PlaceModel
    
    var body: some View {
        VStack(alignment:. leading) {
            Text(place.name)
                .font(.headline)
            Text(place.address)
                .font(.callout)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
