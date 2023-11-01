//  CryptoDetailView.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.


import SwiftUI

struct CryptoDetailView: View {
    let cryptos: Cryptos
    @State var index: Int
    @State var price: Double?
    @State private var showingAddHoldingsSheet = false
    @ObservedObject var viewModel: CryptoDetailViewModel = CryptoDetailViewModel()
    
    var crypto: Cryptocurrency {
        return cryptos[index]
    }
    
    init(cryptos: Cryptos, index: Int) {
        self.cryptos = cryptos
        self._index = State(initialValue: index)
        self._price = State(initialValue: cryptos[index].currentPrice)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                CryptoDetailContent(crypto: crypto, price: $price)
                interactiveChartView()
                marketDataSection()
                Divider()
                Text("Portfolio Holdings")
                    .font(.system(size: 14, weight: .semibold))
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                
                Button(action: {
                    showingAddHoldingsSheet = true
                }) {
                    Text(viewModel.hasHoldings ? crypto.formattedHoldings(currentHoldings: viewModel.holdings ?? 2) : "Add Holdings")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .tint(Color.lagoon)
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                Spacer()
                
                HStack {
                    previousButton
                    nextButton
                }.padding(.horizontal)
                    
                    
                
                
                Spacer()
                    .frame(height: 75)
            }
            .padding(.top, 30)

        }
        .sheet(isPresented: $showingAddHoldingsSheet) {
            AddHoldingsSheetView(crypto: crypto, viewModel: viewModel)
                .presentationDetents([.fraction(0.3)])
        }
        
        .navigationTitle(crypto.name)
        .onAppear {
            price = crypto.currentPrice
            viewModel.fetchHoldings(cryptoId: crypto.id)
        }
        
        .adaptiveBackgroundColor()
    }
    
    
    private func navigationButton(imageName: String, action: @escaping () -> Void, disabled: Bool) -> some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Image(systemName: imageName)
                .font(.headline)
                .frame(maxWidth: 300)
        }
        .tint(Color.lagoon)
        .buttonStyle(.borderless)
        .controlSize(.large)
        .disabled(disabled)
    }
    
    
    private var previousButton: some View {
        navigationButton(imageName: "chevron.left", action: {
            if index > 0 {
                index -= 1
                price = cryptos[index].currentPrice
                viewModel.fetchHoldings(cryptoId: crypto.id)
            }
        }, disabled: index == 0)
    }
    
    private var nextButton: some View {
        navigationButton(imageName: "chevron.right", action: {
            if index < cryptos.count - 1 {
                index += 1
                price = cryptos[index].currentPrice
                viewModel.fetchHoldings(cryptoId: crypto.id)
                
            }
        }, disabled: index == cryptos.count - 1)
    }
    
    
    
    private func interactiveChartView() -> some View {
        InteractiveSparklineChartView(
            selectedPrice: $price,
            initialPrice: crypto.currentPrice,
            data: crypto.sparklineIn7D.price,
            color: crypto.isPriceChangePositive ? .green : .red,
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

struct PrimaryText: View {
    let text: String
    let fontSize: CGFloat
    
    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .medium, design: .rounded))
    }
}

struct SecondaryText: View {
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
