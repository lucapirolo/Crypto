//
//  Cryptocurrency.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import Foundation
import CoreData

/// An array of `Cryptocurrency` objects.
typealias Cryptos = [Cryptocurrency]

/// Represents a cryptocurrency with its market details returned from the CoinGecko API.
struct Cryptocurrency: Decodable {
    /// Unique identifier for the cryptocurrency.
    let id: String

    /// Symbol representing the cryptocurrency (e.g., BTC for Bitcoin).
    let symbol: String

    /// The name of the cryptocurrency.
    let name: String

    /// URL to the image of the cryptocurrency.
    let image: String

    /// Current market price of the cryptocurrency.
    let currentPrice: Double

    /// Total market capitalization.
    let marketCap: Int

    /// Rank based on market capitalization.
    let marketCapRank: Int

    /// Fully diluted market valuation.
    let fullyDilutedValuation: Int?

    /// Total volume of currency traded in the last 24 hours.
    let totalVolume: Double

    /// Highest price of the cryptocurrency in the last 24 hours.
    let high24h: Double

    /// Lowest price of the cryptocurrency in the last 24 hours.
    let low24h: Double

    /// Price change of the cryptocurrency in the last 24 hours.
    let priceChange24h: Double

    /// Percentage change of the price in the last 24 hours.
    let priceChangePercentage24h: Double

    /// Market capitalization change in the last 24 hours.
    let marketCapChange24h: Double

    /// Percentage change of market capitalization in the last 24 hours.
    let marketCapChangePercentage24h: Double

    /// Number of coins in circulation.
    let circulatingSupply: Double

    /// Total supply of the cryptocurrency.
    let totalSupply: Double?

    /// Maximum supply limit of the cryptocurrency.
    let maxSupply: Double?

    /// All-time high price.
    let ath: Double

    /// Percentage change from the all-time high price.
    let athChangePercentage: Double
    
    /// All-time low price.
    let atl: Double

    /// Percentage change from the all-time low price.
    let atlChangePercentage: Double

    /// Last time when the cryptocurrency data was updated.
    let lastUpdated: Date

    /// Coding keys to map JSON keys to the struct properties.
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCapChange24h = "market_cap_change_24h"
        case marketCapChangePercentage24h = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath = "ath"
        case athChangePercentage = "ath_change_percentage"
        case atl = "atl"
        case atlChangePercentage = "atl_change_percentage"
        case lastUpdated = "last_updated"
    }
}


// MARK: - Extension for CryptoCurrencyEntity
extension CryptoCurrencyEntity {
    /// Converts a `CryptoCurrencyEntity` to a `Cryptocurrency`.
    func toModel() -> Cryptocurrency {
        return Cryptocurrency(
            id: id ?? "",
            symbol: symbol ?? "",
            name: name ?? "",
            image: image ?? "",
            currentPrice: currentPrice,
            marketCap: Int(marketCap),
            marketCapRank: Int(marketCapRank),
            fullyDilutedValuation: Int(fullyDilutedValuation),
            totalVolume: Double(totalVolume),
            high24h: high24h,
            low24h: low24h,
            priceChange24h: priceChange24h,
            priceChangePercentage24h: priceChangePercentage24h,
            marketCapChange24h: Double(marketCapChange24h),
            marketCapChangePercentage24h: marketCapChangePercentage24h,
            circulatingSupply: circulatingSupply,
            totalSupply: Double(totalSupply),
            maxSupply: Double(maxSupply),
            ath: ath,
            athChangePercentage: athChangePercentage,
            atl: atl,
            atlChangePercentage: atlChangePercentage,
            lastUpdated: lastUpdated ?? Date.now
        )
    }
}

extension Cryptocurrency {

    /// Converts a `Cryptocurrency` instance to a `CryptoCurrencyEntity`.
    func toEntity(in context: NSManagedObjectContext) -> CryptoCurrencyEntity {
        let entity = CryptoCurrencyEntity(context: context)
        entity.id = id
        entity.symbol = symbol
        entity.name = name
        entity.image = image
        entity.currentPrice = currentPrice
        entity.marketCap = Int64(marketCap)
        entity.marketCapRank = Int64(marketCapRank)
        entity.fullyDilutedValuation = Int64(fullyDilutedValuation ?? 0)
        entity.totalVolume = Int64(totalVolume)
        entity.high24h = high24h
        entity.low24h = low24h
        entity.priceChange24h = priceChange24h
        entity.priceChangePercentage24h = priceChangePercentage24h
        entity.marketCapChange24h = Int64(marketCapChange24h)
        entity.marketCapChangePercentage24h = marketCapChangePercentage24h
        entity.circulatingSupply = circulatingSupply
        entity.totalSupply = Double(totalSupply ?? 0)
        entity.maxSupply = Double(maxSupply ?? 0)
        entity.ath = ath
        entity.athChangePercentage = athChangePercentage
        entity.atl = atl
        entity.atlChangePercentage = atlChangePercentage
        entity.lastUpdated = lastUpdated

        return entity
    }

}
