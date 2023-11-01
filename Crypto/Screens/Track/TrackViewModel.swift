//
//  TrackViewModel.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import Foundation

/// This class is a ViewModel for tracking cryptocurrencies. It handles fetching, caching, and updating data related to cryptocurrency markets.
final class TrackViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var alert: AlertItem? // Alert item to be used for displaying alerts in the view.
    @Published var isLoading = false // A boolean to indicate whether the data is currently being loaded.
    @Published var cryptos: Cryptos? // The main data model holding the list of cryptocurrencies.
    @Published var cachedCryptos: [CryptoCurrencyEntity] = [] // An array holding cached cryptocurrencies.
    

    /// Function to load market data. It fetches cached data and new data if needed.
    /// - Parameter isRefresh: A boolean indicating whether this is a refresh call. Defaults to false.
    func loadMarketData(isRefresh: Bool = false) {
        fetchCachedData()
        
        // Return if data already exists and this is not a refresh call.
        if cryptos != nil && !isRefresh {
              return
          }
        
        // Return if already loading.
        guard !isLoading else { return }
        isLoading = true
    
        // Perform data fetching in a background task.
        Task {
            do {
                try await fetchData()
            } catch {
                handle(error: error) // Handle errors during data fetching.
            }
        }
    }
    
    /// Private function to fetch data asynchronously.
    private func fetchData() async throws {
        // Attempt to get market data from the network.
        if let response = try await NetworkManager.shared.getMarketData() {
            processResponse(response) // Process the successful response.
        } else {
            // Handle case where response is nil.
            DispatchQueue.main.async {
                self.alert = AlertContext.unableToComplete
            }
        }
    }
    
    /// Private function to process the successful response.
    /// - Parameter response: The response containing cryptocurrency data.
    private func processResponse(_ response: Cryptos) {
        // Update the state on the main thread.
        DispatchQueue.main.async {
            self.cryptos = response // Update the cryptocurrency list.
            PersistenceController.shared.saveCryptocurrencies(response) // Save the data for caching.
            self.isLoading = false // Update loading state.
        }
    }
    
    /// Function to fetch cached data from the persistence layer.
    func fetchCachedData() {
        self.cachedCryptos = PersistenceController.shared.fetchCachedCryptos()
    }

    
    /// Private function to handle errors during data fetching.
    /// - Parameter error: The error that occurred during data fetching.
    private func handle(error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false // Update loading state.
        }
        // Handle network errors.
        if let networkError = error as? NetworkError {
            DispatchQueue.main.async {
                self.alert = networkError.alertItem // Set the alert item based on the network error.
            }
           
        } else {
            // Handle other errors.
            DispatchQueue.main.async {
                self.alert = AlertContext.unableToComplete // Set a generic alert item.
            }
        }
    }
}
