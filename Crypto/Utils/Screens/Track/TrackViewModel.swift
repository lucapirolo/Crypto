//
//  TrackViewModel.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import Foundation

final class TrackViewModel: ObservableObject {
    @Published var alert: AlertItem?
    @Published var isLoading = false
    @Published var cryptos: Cryptos?
    @Published var cachedCryptos: [CryptoCurrencyEntity] = []
    

    func loadMarketData(isRefresh: Bool = false) {
        fetchCachedData()
        
        if cryptos != nil && !isRefresh {
              return
          }
          
        guard !isLoading else { return }
        isLoading = true
    
        Task {
            do {
                try await fetchData()
            } catch {
                handle(error: error)
            }
        }
    }
    
    private func fetchData() async throws {
        if let response = try await NetworkManager.shared.getMarketData() {
            processResponse(response)
        } else {
            DispatchQueue.main.async {
                self.alert = AlertContext.unableToComplete
            }
        }
    }
    
    private func processResponse(_ response: Cryptos) {
        // Append new data instead of reassigning
        DispatchQueue.main.async {
            self.cryptos = response
            PersistenceController.shared.saveCryptocurrencies(response)
            self.isLoading = false
        }
    }
    
    func fetchCachedData() {
        self.cachedCryptos = PersistenceController.shared.fetchCachedCryptos()
    }

    
    private func handle(error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
        if let networkError = error as? NetworkError {
            DispatchQueue.main.async {
                self.alert = networkError.alertItem
            }
           
        } else {
            DispatchQueue.main.async {
                self.alert = AlertContext.unableToComplete
            }
        }
    }
}

