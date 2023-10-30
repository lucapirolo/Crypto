//
//  CryptoRow.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI

struct CryptoRow: View {
    var crypto: Cryptocurrency

    var body: some View {
        HStack {
            RankLabel(rank: crypto.marketCapRank)
            CryptoImageView(imageURL: crypto.image, width: 30, height: 30, cornerRadius: 8)
            CryptoDetails(name: crypto.name, symbol: crypto.symbol)
            Spacer()
            SparklineChart(data: crypto.sparklineIn7D.price, isPostiveChange: crypto.isPriceChangePositive)
            VStack(alignment: .trailing) {
                PriceLabel(price: crypto.formattedCurrentPrice)
                PriceChangeView(crypto: crypto)
                    .font(.footnote)
            }
        }
        .padding(EdgeInsets(top: 20, leading: 26, bottom: 20, trailing: 26))
    }
}

private struct SparklineChart: View {
    let data: [Double]
    let isPostiveChange: Bool
    var body: some View {
        SparklineChartView(data: data, color: isPostiveChange ? .green : .red)
            .frame(height: 30)
            .padding(.leading, 60)
            .padding(.trailing, 12)
    }
}

private struct RankLabel: View {
    let rank: Int
    
    var body: some View {
        Text(String(rank))
            .font(.system(size: 12, weight: .bold))
            .padding(.trailing, 6)
    }
}


private struct CryptoDetails: View {
    let name: String
    let symbol: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name).font(.acumin(.bold, size: 16))
            Text(symbol).textCase(.uppercase).font(.acumin(.regular, size: 12)).foregroundColor(.secondary)
        }
    }
}

private struct PriceLabel: View {
    let price: String
    
    var body: some View {
        Text(price)
            .font(.system(size: 14, weight: .bold))
            .animation(.easeIn)
    }
}

struct PriceChangeView: View {
    let isPositive: Bool
    let text: String
    
    init(crypto: Cryptocurrency) {
        self.isPositive = crypto.isPriceChangePositive
        self.text = crypto.formattedPriceChangePercentage
    }
    
    var body: some View {
        Text(text)
            .foregroundColor(isPositive ? .green : .red)
            .animation(.easeIn)
    }
}
