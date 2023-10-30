//
//  SparklineCharts.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.
//

import SwiftUI
import Charts

struct SparklineSmallChartView: View {
    var data: [Double]
    var color: Color = .lagoon

    var body: some View {
        let max = data.max() ?? 0
        let min = data.min() ?? 0
        let padding = (max - min) * 0.1 // 10% padding

        Chart {
            ForEach(data.indices, id: \.self) { index in
                let value = data[index]
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", value)
                    )
                    
                     .interpolationMethod(.linear)
            }
        }
        .animation(.easeIn, value: data)
        .chartLegend(.hidden)
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartYScale(domain: (min - padding)...(max + padding))

    }
}
