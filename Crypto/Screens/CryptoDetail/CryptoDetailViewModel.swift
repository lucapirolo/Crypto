//
//  CryptoDetailViewModel.swift
//  Crypto
//
//  Created by Luca Pirolo on 31/10/2023.
//

import SwiftUI

class CryptoDetailViewModel: ObservableObject {
    @Published var holdings: Double?
    private let persistenceController = PersistenceController.shared
   
    var hasHoldings: Bool {
        return !(holdings == nil || holdings == 0)
    }

    func fetchHoldings(cryptoId: String) {
        if let cryptoEntity = persistenceController.fetchCrypto(byId: cryptoId) {
            DispatchQueue.main.async {
                print(cryptoEntity.holdings)
                self.holdings = cryptoEntity.holdings
            }
        }
    }

    func addHoldings(cryptoId: String, _ amount: Double) {
        guard !cryptoId.isEmpty, amount > 0 else {
             return
         }
        
        persistenceController.setHoldings(for: cryptoId, holdings: amount)
        fetchHoldings(cryptoId: cryptoId)
    }
}

