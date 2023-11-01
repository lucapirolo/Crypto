//  CryptoDetailViewModel.swift
//  Crypto
//
//  Created by Luca Pirolo on 31/10/2023.
//

import SwiftUI

/// ViewModel for viewing crypto details, including fetching and updating holdings information.
class CryptoDetailViewModel: ObservableObject {
    @Published var holdings: Double?
    private let persistenceController = PersistenceController.shared
   
    /// Determines if there are any holdings.
    var hasHoldings: Bool {
        return !(holdings == nil || holdings == 0)
    }

    /// Fetches holdings for a specific crypto by its ID.
    ///
    /// - Parameter cryptoId: The identifier of the crypto.
    func fetchHoldings(cryptoId: String) {
        if let cryptoEntity = persistenceController.fetchCrypto(byId: cryptoId) {
            DispatchQueue.main.async {
                self.holdings = cryptoEntity.holdings
            }
        }
    }

    /// Adds holdings for a specific crypto.
    ///
    /// - Parameters:
    ///   - cryptoId: The identifier of the crypto.
    ///   - amount: The amount of holdings to add.
    func addHoldings(cryptoId: String, _ amount: Double) {
        guard !cryptoId.isEmpty, amount >= 0 else {
             return
         }
        
        persistenceController.setHoldings(for: cryptoId, holdings: amount)
        fetchHoldings(cryptoId: cryptoId)
    }
}
