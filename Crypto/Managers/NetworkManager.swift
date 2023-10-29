//
//  NetworkManager.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import Foundation

final class NetworkManager: BaseNetworkManager {
    static let shared = NetworkManager()
    
    /// Retrieves market data for cryptocurrencies.
    /// - Parameter pagination: The pagination parameters to control data fetching.
    /// - Returns: A result containing an array of `Cryptocurrency`
    func getMarketData(pagination: Pagination) async throws -> Cryptos? {
        let endpoint = ApiControllers.coins + ApiEnpoints.markets
        return try await sendRequest(endpoint, method: .get, responseType: Cryptos.self, pagination: pagination)
    }
    

}
