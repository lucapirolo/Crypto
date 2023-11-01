//
//  TrackView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI
import Charts

/// A view for tracking cryptocurrency market data.
struct TrackView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: TrackViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    
    /// Computes the cryptocurrencies to be displayed.
    var cryptos: Cryptos {
        viewModel.cryptos ?? viewModel.cachedCryptos.map { $0.toModel() }
    }
    
    /// Filters the cryptocurrencies based on the search text.
    var filteredCryptos: Cryptos {
        guard !searchText.isEmpty else {
            return cryptos
        }
        return cryptos.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    // MARK: - Initialization
    
    init(viewModel: TrackViewModel) {
        self.viewModel = viewModel
        UINavigationBar.configureCryptoNavBarAppearance()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundView
                contentGroup
                    .searchable(text: $searchText, prompt: "Search Coins")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Track Coins")
                    .onAppear {
                        viewModel.loadMarketData()
                    }
                    .showAlert(alert: $viewModel.alert)
            }
        }
    }
    
    // MARK: - Private Views
    
    /// The background view for the track view.
    private var backgroundView: some View {
        Color.dynamicBackgroundColor(for: colorScheme)
            .edgesIgnoringSafeArea(.all)
    }
    
    /// The main content group containing the list of cryptocurrencies or appropriate messages.
    private var contentGroup: some View {
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
    }
    
    /// Scroll view containing the list of cryptocurrencies.
    private var cryptoScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(filteredCryptos, id: \.id) { crypto in
                    VStack {
                        cryptoRow(for: crypto)
                        Divider().padding(.horizontal)
                    }
                }
                Spacer().frame(height: 50)  // Add spacer at the bottom
            }
        }
        .refreshable {
            viewModel.loadMarketData(isRefresh: true)
        }
    }
    
    /// View for a single cryptocurrency row.
    /// - Parameter crypto: The cryptocurrency data to display.
    /// - Returns: A view representing a single row.
    private func cryptoRow(for crypto: Cryptocurrency) -> some View {
        NavigationLink(destination: CryptoDetailView(cryptos: cryptos, index: cryptos.lastIndex(of: crypto) ?? 0)) {
            CryptoRow(crypto: crypto)
                .transition(.slide)
                .animation(.easeInOut, value: filteredCryptos)
        }
        .buttonStyle(PlainButtonStyle())
    
    }
    
    // MARK: - Previews
    struct TrackView_Previews: PreviewProvider {
        static var previews: some View {
            TrackView(viewModel: TrackViewModel())
        }
    }
}
