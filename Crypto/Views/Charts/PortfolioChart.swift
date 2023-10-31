//
//  PortfolioChart.swift
//  Crypto
//
//  Created by Luca Pirolo on 31/10/2023.
//

import SwiftUI
import Charts


struct GradientAreaChartExampleView: View {
    var sampleCryptoData: [CryptoAsset] // Make sure this is populated with your crypto data

    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.4), Color.accentColor.opacity(0)]), startPoint: .top, endPoint: .bottom)

    var body: some View {
        Chart {
            ForEach(sampleCryptoData) { data in
                LineMark(x: .value("Hour", data.hour), y: .value("Price", data.price))
            }
            .interpolationMethod(.cardinal)

            ForEach(sampleCryptoData) { data in
                AreaMark(x: .value("Hour", data.hour), y: .value("Price", data.price))
                .interpolationMethod(.cardinal)
                .foregroundStyle(linearGradient)
            }
        }
        .chartXAxis {
            // Using Date type here
          
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}
