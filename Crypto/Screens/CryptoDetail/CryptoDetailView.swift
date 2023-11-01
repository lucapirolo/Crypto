//  CryptoDetailView.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.


import SwiftUI

struct CryptoDetailView: View {
    let cryptos: Cryptos
    @State private var index: Int
    @State private var price: Double?
    @State private var showingAddHoldingsSheet = false
    @ObservedObject private var viewModel: CryptoDetailViewModel = CryptoDetailViewModel()
    
    private var crypto: Cryptocurrency {
        cryptos[index]
    }
    
    init(cryptos: Cryptos, index: Int) {
        self.cryptos = cryptos
        self._index = State(initialValue: index)
        self._price = State(initialValue: cryptos[index].currentPrice)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                CryptoDetailContent(crypto: crypto, price: $price)
                interactiveChartView()
                Divider()
                marketDataSection()
                Divider()
                VStack {
                    Text("Portfolio Holdings").sectionHeaderStyle()
                    portfolioHoldingsButton()
                }
                Divider()
                navigationButtons()
                Spacer()
                    .frame(height: 60)
            }
            .padding(.top, 30)
            
           
        }
        .sheet(isPresented: $showingAddHoldingsSheet) {
            AddHoldingsSheetView(crypto: crypto, viewModel: viewModel)
                .presentationDetents([.fraction(0.3)])
        }
        .navigationTitle(crypto.name)
        .onAppear(perform: fetchCryptoDetails)
        .adaptiveBackgroundColor()
    }
    
    private func fetchCryptoDetails() {
        price = crypto.currentPrice
        viewModel.fetchHoldings(cryptoId: crypto.id)
    }
    
    private func navigationButton(imageName: String, action: @escaping () -> Void, disabled: Bool) -> some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.headline)
                .frame(maxWidth: 300)
        }
        .buttonStyleProperties(isDisabled: disabled)
    }
    
    private var previousButton: some View {
        navigationButton(
            imageName: "chevron.left",
            action: navigateToPrevious,
            disabled: index == 0
        )
    }
    
    private var nextButton: some View {
        navigationButton(
            imageName: "chevron.right",
            action: navigateToNext,
            disabled: index == cryptos.count - 1
        )
    }
    
    private func navigateToPrevious() {
        withAnimation {
            if index > 0 {
                index -= 1
                updatePriceAndHoldings()
            }
        }
    }
    
    private func navigateToNext() {
        withAnimation {
            if index < cryptos.count - 1 {
                index += 1
                updatePriceAndHoldings()
            }
        }
    }
    
    private func updatePriceAndHoldings() {
        price = cryptos[index].currentPrice
        viewModel.fetchHoldings(cryptoId: crypto.id)
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
        Section(header: Text("Market Data").sectionHeaderStyle()) {
            VStack {
                HStack(spacing: 20) {
                    MarketDataItem(title: "Market Cap", value: crypto.marketCap.formattedAsShort())
                    MarketDataItem(title: "Total Volume", value: crypto.totalVolume.formattedAsShort())
                    MarketDataItem(title: "Rank", value: "#\(crypto.marketCapRank)")
                }
                .padding(.top, 8)
                MarketDataView(crypto: crypto)
            }
        }
    }
    
    private func portfolioHoldingsButton() -> some View {
        Button(action: { showingAddHoldingsSheet = true }) {
            Text(viewModel.hasHoldings ? crypto.formattedHoldings(currentHoldings: viewModel.holdings ?? 2) : "Add Holdings")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .primaryButtonStyle()
    }
    
    private func navigationButtons() -> some View {
        HStack {
            previousButton
            nextButton
        }
        .padding(.horizontal)
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
