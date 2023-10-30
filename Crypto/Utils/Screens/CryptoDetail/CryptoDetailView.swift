//  CryptoDetailView.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.


import SwiftUI

struct CryptoDetailView: View {
    let cryptos: Cryptos
    @State var index: Int
    @State var price: Double?
    
    var crypto: Cryptocurrency {
        return cryptos[index]
    }
    
    var body: some View {
        VStack {
            CryptoDetailContent(crypto: crypto, price: $price)
            interactiveChartView()
            marketDataSection()
            Spacer()
            nextButton()
            Spacer()
        }
        .padding(.top, 30)
        .adaptiveBackgroundColor()
        .navigationTitle(crypto.name)
        .onAppear {
            price = crypto.currentPrice
        }
    }
    
    private func nextButton() -> some View {
          Button(action: {
              withAnimation {
                  index += 1
                  price = crypto.currentPrice
              }
          }) {
              Text("Next Coin")
                  .font(.headline)
                  .frame(maxWidth: 300)
          }
          .tint(Color.lagoon)
          .buttonStyle(.bordered)
          .controlSize(.large)
          .disabled(index >= cryptos.count - 1)  // Disable the button if there are no more items
      }

    private func interactiveChartView() -> some View {
        InteractiveSparklineChartView(
            selectedPrice: $price,
            initialPrice: crypto.currentPrice,
            data: crypto.sparklineIn7D.price,
            color: .lagoon,
            chartPlotPadding: 0.40
        )
        .padding(.horizontal)
    }
    
    private func marketDataSection() -> some View {
        Section {
            VStack {
                HStack {
                    MarketDataItem(title: "Market Cap", value: crypto.marketCap.formattedAsShort())
                        .frame(maxWidth: .infinity)  // Makes this item take up equal width

                    MarketDataItem(title: "Total Volume", value: crypto.totalVolume.formattedAsShort())
                        .frame(maxWidth: .infinity)  // Makes this item take up equal width

                    MarketDataItem(title: "Rank", value: "#\(crypto.marketCapRank)")
                        .frame(maxWidth: .infinity)  // Makes this item take up equal width
                }
                .padding(.top, 8)
                .padding(.horizontal, 20)
                Divider()
                
                MarketDataView(crypto: crypto)
                
            }
          
        } header: {
                Text("Market Data")
                    .font(.system(size: 14, weight: .semibold))
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    
        }
    }
}

private struct MarketDataItem: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .textCase(.uppercase)
                .foregroundColor(.secondary)
            Text(value)
                .animation(.easeIn)
        }
    }
}


private struct CryptoDetailContent: View {
    let crypto: Cryptocurrency
    @Binding var price: Double?
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                CryptoHeader(crypto: crypto)
                CryptoPrice(price: $price)
                
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
    @Binding var price: Double?
    var body: some View {
        HStack(spacing: 5) {
            SecondaryText(text: "£", fontSize: 24)
            PrimaryText(text: price?.formattedCurrencyWithoutSymbol ?? "", fontSize: 32)
       
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
        CryptoDetailView(cryptos: Cryptos.placeholders, index: 1)
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

struct MarketDataView: View {
    let crypto: Cryptocurrency
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            MarketDataRow(
                          leftTitle: "Circulating",
                          leftValue: crypto.formattedCirculatingSupply,
                          rightTitle: "Max Supply",
                          rightValue: crypto.formattedMaxSupply
                      )
                      
                      MarketDataRow(
                          leftTitle: "ATL",
                          leftValue: crypto.formattedAllTimeLow,
                          rightTitle: "ATH",
                          rightValue: crypto.formattedAllTimeHigh
                      )
        }
        .padding(20)
  
    }
}



