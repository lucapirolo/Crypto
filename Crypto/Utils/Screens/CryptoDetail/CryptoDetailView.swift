//  CryptoDetailView.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.

import SwiftUI

struct CryptoDetailView: View {
    let crypto: Cryptocurrency
    
    var body: some View {
        VStack {
            CryptoDetailContent(crypto: crypto)
            Spacer()
        }
        .padding(.top, 30)
        .adaptiveBackgroundColor()
        .navigationTitle(crypto.name)
    }
}

private struct CryptoDetailContent: View {
    let crypto: Cryptocurrency
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                CryptoHeader(crypto: crypto)
                CryptoPrice(price: crypto.formattedCurrentPriceWithoutCurrency)
                
            }
            Spacer()
            PriceChangeView(crypto: crypto)
        }.padding(.horizontal)
    }
}

private struct CryptoHeader: View {
    let crypto: Cryptocurrency
    
    var body: some View {
        HStack(alignment: .center) {
            CryptoImageView(imageURL: crypto.image, width: 40)
            CryptoName(name: crypto.name)
        }
        .padding(.bottom, 4)
    }
}

private struct CryptoName: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.acumin(.regular, size: 26))
            .padding(.top, 3)
    }
}

private struct CryptoPrice: View {
    let price: String
    
    var body: some View {
        HStack(spacing: 5) {
            SecondaryText(text: "£", fontSize: 24)
            PrimaryText(text: price, fontSize: 32)
            SecondaryText(text: " GBP", fontSize: 18)
        }
    }
}

private struct PrimaryText: View {
    let text: String
    let fontSize: CGFloat

    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .medium, design: .rounded))
    }
}

private struct SecondaryText: View {
    let text: String
    let fontSize: CGFloat

    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
    }
}

struct CryptoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoDetailView(crypto: Cryptos.placeholders[0])
    }
}
