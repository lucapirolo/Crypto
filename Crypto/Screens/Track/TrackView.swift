//
//  TrackView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI

struct TrackView: View {
    @StateObject private var viewModel = TrackViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest(
        entity: CryptoCurrencyEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CryptoCurrencyEntity.marketCapRank, ascending: true)]
    ) var cachedCryptoCurrencies: FetchedResults<CryptoCurrencyEntity>
    
    var cryptos: Cryptos {
        return viewModel.cryptos ?? cachedCryptoCurrencies.map { $0.toModel() }
    }
    
    init() {
        UINavigationBar.configureCryptoNavBarAppearance()
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if !cryptos.isEmpty {
                    cryptoScrollView
                } else {
                    Text("Failed To Load")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Track Coins")
            .onAppear {
                viewModel.loadMarketData()
            }
            .showAlert(alert: $viewModel.alert)
        }
    }
    
    private var cryptoScrollView: some View {
          ScrollView {
              LazyVStack(spacing: 0) {
                  ForEach(cryptos, id: \.id) { crypto in
                      CryptoRow(crypto: crypto)
                      Divider()
                          .padding(.horizontal)
                  }
              }
          }
          .background(colorScheme == .dark ? Color.midnight : Color(uiColor: UIColor.systemBackground))

      }

}

struct CryptoRow: View {
    var crypto: Cryptocurrency

    var body: some View {
        HStack {
            rankLabel
            cryptoImage
            cryptoDetails
            Spacer()
        }
        .padding(EdgeInsets(top: 20, leading: 26, bottom: 20, trailing: 26))

    }
    
    private var rankLabel: some View {
        Text(String(crypto.marketCapRank))
            .font(.system(size: 12, weight: .bold))
            .padding(.trailing, 6)
    }
    
    private var cryptoImage: some View {
        AsyncImage(url: URL(string: crypto.image)) { phase in
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
    
    private var cryptoDetails: some View {
        VStack(alignment: .leading) {
            Text(crypto.name).font(.acumin(.bold, size: 16))
            Text(crypto.symbol).textCase(.uppercase).font(.acumin(.regular, size: 12)).foregroundColor(.secondary)
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
