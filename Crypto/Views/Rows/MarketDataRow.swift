//
//  MarketDataRow.swift
//  Crypto
//
//  Created by Luca Pirolo on 01/11/2023.
//

import SwiftUI

struct MarketDataRow: View {
    var leftTitle: String
    var leftValue: String
    var rightTitle: String
    var rightValue: String
    
    
    var body: some View {
        HStack(spacing: 20) {
            MarketDataRowItem(title: leftTitle, value: leftValue)
            Spacer()
            MarketDataRowItem(title: rightTitle, value: rightValue)
        }
    }
}

struct MarketDataRowItem: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack(spacing: 5) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 12))
                .animation(.easeIn)
        }
    }
}
