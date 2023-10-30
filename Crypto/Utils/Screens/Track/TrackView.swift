//
//  TrackView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI
import Charts

struct TrackView: View {
    @ObservedObject var viewModel: TrackViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    

    
    var cryptos: Cryptos {
        return viewModel.cryptos ?? viewModel.cachedCryptos.map { $0.toModel() }
    }

    var filteredCryptos: Cryptos {
        guard !searchText.isEmpty else {
            return cryptos
        }
        
        return cryptos.filter { crypto in
            crypto.name.lowercased().contains(searchText.lowercased())
        }
    }

    init(viewModel: TrackViewModel) {
           self.viewModel = viewModel
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
            .adaptiveBackgroundColor() // Apply the background to the whole Group
            .searchable(text: $searchText, prompt: "Search Coins")
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
                ForEach(filteredCryptos, id: \.id) { crypto in
                    NavigationLink(destination: CryptoDetailView(cryptos: cryptos, index: cryptos.lastIndex(of: crypto) ?? 0)) {
                        CryptoRow(crypto: crypto)
                            .transition(.slide)
                            .animation(.easeInOut, value: filteredCryptos)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                        .padding(.horizontal)
                    
                }
            }
        }
        .refreshable {
            viewModel.loadMarketData(isRefresh: true)
        }
    }
    
}



struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(viewModel: TrackViewModel())
    }
}

