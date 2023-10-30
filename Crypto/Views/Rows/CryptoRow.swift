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
            CryptoImageView(imageURL: crypto.image)
            CryptoDetails(name: crypto.name, symbol: crypto.symbol)
            Spacer()
            SparklineChart(data: crypto.sparklineIn7D.price)
            VStack(alignment: .trailing) {
                PriceLabel(price: crypto.formattedCurrentPrice)
                PriceChangeView(isPositive: crypto.isPriceChangePositive, text: crypto.formattedPriceChangePercentage)
            }
        }
        .padding(EdgeInsets(top: 20, leading: 26, bottom: 20, trailing: 26))
    }
}

private struct SparklineChart: View {
    let data: [Double]
    var body: some View {
        SparklineSmallChartView(data: data)
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

private struct CryptoImageView: View {
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                Color.secondary.frame(width: 30, height: 30).cornerRadius(8)
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fill).transition(.opacity)
            case .failure:
                Image(systemName: "photo").frame(width: 30, height: 30).cornerRadius(8)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 25, height: 25)
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

private struct PriceChangeView: View {
    let isPositive: Bool
    let text: String
    
    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(isPositive ? .green : .red)
            .animation(.easeIn)
    }
}
