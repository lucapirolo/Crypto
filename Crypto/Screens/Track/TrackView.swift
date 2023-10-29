//
//  TrackView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI

struct TrackView: View {
    // Observe changes from TrackViewModel
    @StateObject private var viewModel = TrackViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    // Display a loading indicator when data is being fetched
                    ProgressView()
                } else {
                    // Display the list of cryptocurrencies
                    List(viewModel.cryptos, id: \.id) { crypto in
                        HStack {
                            Text(crypto.name)
                            Spacer()

                        }
                    }
                }
            }
            .navigationTitle("Crypto Tracker")
            .onAppear {
                // Load market data when the view appears
                viewModel.loadMarketData()
            }
            .alert(item: $viewModel.alert) { alertItem in
                // Show an alert for errors
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
