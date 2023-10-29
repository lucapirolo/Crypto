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
        let endpoint = "/" + ApiControllers.coins + "/" + ApiEnpoints.markets

        let queryParams: [String: String] = [
            "vs_currency": "usd",
            "order": "market_cap_desc",
            "sparkline": "false",
            "locale": "en"
        ]
    
        return try await sendRequest(
            endpoint,
            method: .get,
            responseType: Cryptos.self,
            pagination: pagination,
            queryParams: queryParams
        )
    }

    

}
