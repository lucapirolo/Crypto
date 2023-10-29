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
    private var pagination = Pagination.standard
    private var loadMore = true
    
    func loadMarketData() {
        guard loadMore else { return }
        
        isLoading = pagination.currentPage == 0
        
        Task {
            do {
                try await fetchData()
            } catch {
                handle(error: error)
            }
        }
    }
    
    private func fetchData() async throws {
        if let response = try await NetworkManager.shared.getMarketData(pagination: pagination) {
            processResponse(response)
        } else {
            DispatchQueue.main.async {
                self.alert = AlertContext.unableToComplete
            }
        }
    }
    
    private func processResponse(_ response: Cryptos) {
        loadMore = response.count == pagination.itemsPerPage
        if loadMore {
            pagination.nextPage()
        }
        // Append new data instead of reassigning
        DispatchQueue.main.async {
            if self.cryptos == nil {
                self.cryptos = []
            }
            self.cryptos?.append(contentsOf: response)
            PersistenceController.shared.saveCryptocurrencies(self.cryptos ?? [])
            self.isLoading = false
        }
        
        
        
              
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

