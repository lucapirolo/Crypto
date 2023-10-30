//
//  SparklineCharts.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.
//

import SwiftUI
import Charts

struct SparklineChartView: View {
    var data: [Double]
    var color: Color = .lagoon
    var chartPlotPadding: Double = 0.1

    var body: some View {
        let max = data.max() ?? 0
        let min = data.min() ?? 0
        let padding = (max - min) * chartPlotPadding // 10% padding

        Chart {
            ForEach(data.indices, id: \.self) { index in
                let value = data[index]
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(color.gradient)
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

struct InteractiveSparklineChartView: View {
    @Binding var selectedPrice: Double?
     var initialPrice: Double
     var data: [Double]
     var color: Color = .lagoon
     var chartPlotPadding: Double = 0.1

     @State private var currentActiveIndex: Int?
     @State private var plotWidth: CGFloat = 0
     @State private var tempSelectedPrice: Double?

    var body: some View {
        let max = data.max() ?? 0
        let min = data.min() ?? 0
        let adjustedPadding = (max - min) * chartPlotPadding // Padding adjustment

        ZStack {
            Chart {
                ForEach(data.indices, id: \.self) { index in
                    let value = data[index]
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", value)
                    )
                    .interpolationMethod(.linear)
                    .foregroundStyle(color.gradient)
                }
            }
            .animation(.easeIn, value: data)
            .chartXAxis(.hidden)
            .chartYScale(domain: (min - adjustedPadding)...(max + adjustedPadding))
            .chartOverlay(content: { proxy in
                GeometryReader { innerProxy in
                    Rectangle()
                        .fill(Color.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let location = value.location
                                    if let index: Int = proxy.value(atX: location.x), data.indices.contains(index) {
                                        self.currentActiveIndex = index
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }.onEnded { value in
                                    self.currentActiveIndex = nil
                                }
                        )
                }
            })
            .frame(height: 200) // Adjust the height as needed

            // Pointer View
            if let currentActiveIndex = currentActiveIndex, data.indices.contains(currentActiveIndex) {
                PointerView(price: data[currentActiveIndex], index: currentActiveIndex, plotWidth: plotWidth, count: data.count)
            }
        }
        .onAppear {
               tempSelectedPrice = selectedPrice
           }
           .onChange(of: currentActiveIndex) { newIndex in
               if let newIndex = newIndex, data.indices.contains(newIndex) {
                   tempSelectedPrice = data[newIndex]
               } else {
                   tempSelectedPrice = initialPrice
               }
           }
           .onChange(of: tempSelectedPrice) { newPrice in
               selectedPrice = newPrice
           }
    }
}

struct PointerView: View {
    var price: Double
    var index: Int
    var plotWidth: CGFloat
    var count: Int
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.secondary)
                .frame(width: 1, height: 30)
                .offset(x: positionOffset(), y: -65)
        }
    }
    
    // Calculate the position offset for the pointer
    private func positionOffset() -> CGFloat {
        let step = plotWidth / CGFloat(count)
        return step * CGFloat(index) - plotWidth / 2
    }
}





