//
//  TrackView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI
import Charts

struct TrackView: View {
    @StateObject private var viewModel = TrackViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    
    @FetchRequest(
        entity: CryptoCurrencyEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CryptoCurrencyEntity.marketCapRank, ascending: true)]
    ) var cachedCryptoCurrencies: FetchedResults<CryptoCurrencyEntity>
    
    var cryptos: Cryptos {
        return viewModel.cryptos ?? cachedCryptoCurrencies.map { $0.toModel() }
    }
    
    var filteredCryptos: Cryptos {
          if searchText.isEmpty {
              return viewModel.cryptos ?? cachedCryptoCurrencies.map { $0.toModel() }
          } else {
              return (viewModel.cryptos ?? cachedCryptoCurrencies.map { $0.toModel() }).filter { crypto in
                  crypto.name.lowercased().contains(searchText.lowercased())
              }
          }
      }
    
    init() {
        UINavigationBar.configureCryptoNavBarAppearance()
    }
    
    var body: some View {
        NavigationView {
            Group {
               if viewModel.isLoading && filteredCryptos.isEmpty {
                   ProgressView()
               } else if !filteredCryptos.isEmpty {
                   cryptoScrollView
               } else {
                   Text("Nothing To Show!")
                       .frame(maxWidth: .infinity, maxHeight: .infinity)
               }
           }
            .background(colorScheme == .dark ? Color.midnight : Color(uiColor: UIColor.systemBackground)) // Apply the background to the whole Group
            .searchable(text: $searchText, prompt: "Search Coins")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Track Coins")
            .onAppear {
//                viewModel.loadMarketData()
            }
            .showAlert(alert: $viewModel.alert)
        }
    }
    
    private var cryptoScrollView: some View {
          ScrollView {
              LazyVStack(spacing: 0) {
                  ForEach(filteredCryptos, id: \.id) { crypto in
                      CryptoRow(crypto: crypto)
                          .transition(.slide)
                          .animation(.easeInOut, value: filteredCryptos)
                      Divider()
                          .padding(.horizontal)
                      
                  }
              }
          }
          .refreshable {
              viewModel.loadMarketData()
          }
      }

}



struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}

struct ChartView: View {
    var sparklineData: SparklineIn7D

    var body: some View {
        VStack {
        
            ReusableViewChart(data: sparklineData.price, isLineGraph: true)
        }
        .padding()
    }
}

struct ReusableViewChart: View {
    var data: [Double]
    var isLineGraph: Bool
    
    // Additional properties if needed
    var color: Color = Color("Blue")

    var body: some View {
        let max = data.max() ?? 0
        let min = data.min() ?? 0
        let padding = (max - min) * 0.1 // 10% padding

        Chart {
            ForEach(data.indices, id: \.self) { index in
                let value = data[index]
                
                if isLineGraph {
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", value)
                    )
                    // Uncomment and adjust as needed
                    // .foregroundStyle(color.gradient)
                    // .interpolationMethod(.linear)
                } else {
                    BarMark(
                        x: .value("Index", index),
                        y: .value("Value", value)
                    )
                    // Uncomment and adjust as needed
                    // .foregroundStyle(color.gradient)
                }
            }
        }
        .chartYScale(domain: (min - padding)...(max + padding))
        .frame(height: 250) // Adjust height as needed
    }
}

