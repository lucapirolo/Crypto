//
//  Cryptocurrency.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import Foundation
import CoreData


/// Represents a cryptocurrency with its market details returned from the CoinGecko API.
struct Cryptocurrency: Decodable, Equatable {
    static func == (lhs: Cryptocurrency, rhs: Cryptocurrency) -> Bool {
        return lhs.id == rhs.id
    }
    
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
    let ath: Double?
    
    /// Percentage change from the all-time high price.
    let athChangePercentage: Double
    
    /// All-time low price.
    let atl: Double?
    
    /// Percentage change from the all-time low price.
    let atlChangePercentage: Double
    
    /// Last time when the cryptocurrency data was updated.
    let lastUpdated: Date
    
    /// The prices over the last 7 days
    let sparklineIn7D: SparklineIn7D
    
    // Local property to hold the user's holdings of the cryptocurrency.
    // This property is not part of the JSON and should be ignored during decoding.
    var holdings: Double = 0.0
    
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
        case sparklineIn7D = "sparkline_in_7d"
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]
    
    enum CodingKeys: String, CodingKey {
        case price
    }
    
    func encodeToData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    static func decodeFromData(_ data: Data) throws -> SparklineIn7D {
        let decoder = JSONDecoder()
        return try decoder.decode(SparklineIn7D.self, from: data)
    }
}


/// An array of `Cryptocurrency` objects.
typealias Cryptos = [Cryptocurrency]

extension Cryptos {
    // Computed property to get the sum of the holdings value
    var sumOfHoldingsValue: Double {
        return self.reduce(0) { $0 + ($1.holdings * $1.currentPrice) }
    }
    
    // Computed property to get the most valuable holding
    var mostValuableHolding: Cryptocurrency? {
        return self.max(by: { ($0.holdings * $0.currentPrice) < ($1.holdings * $1.currentPrice) })
    }
    
    var formattedSumOfHoldingsValue: String {
        let customFormatter = NumberFormatter()
        customFormatter.numberStyle = .currency
        customFormatter.currencySymbol = ""
        customFormatter.maximumFractionDigits = 2
        customFormatter.minimumFractionDigits = 2

        guard let formattedPrice = customFormatter.string(from: NSNumber(value: sumOfHoldingsValue)) else {
            return "0.00"
        }
        return formattedPrice
    }
    
    
    static let placeholders: Cryptos = Bundle.main.decode(PlaceholderFileNames.markets)
}

extension Array where Element == Cryptocurrency {
    // Method to sort cryptocurrencies by the value of their holdings
    func sortedByMostValuableHolding() -> [Cryptocurrency] {
        return self.sorted { ($0 as Cryptocurrency).valueOfHoldings > ($1 as Cryptocurrency).valueOfHoldings }
    }
}


// MARK: - Extension for CryptoCurrencyEntity
extension CryptoCurrencyEntity {
    /// Converts a `CryptoCurrencyEntity` to a `Cryptocurrency`.
    func toModel() -> Cryptocurrency {
        var sparkline: SparklineIn7D? = nil
        
        // Decode SparklineIn7D if available
        if let sparklineData = sparklineIn7D {
            do {
                sparkline = try SparklineIn7D.decodeFromData(sparklineData)
            } catch {
                print("Error decoding sparkline data: \(error)")
            }
        }
        
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
            lastUpdated: lastUpdated ?? Date.now,
            sparklineIn7D: sparkline ?? SparklineIn7D(price: []),
            holdings: holdings
        )
    }
    
    func update(with crypto: Cryptocurrency) {
        self.id = crypto.id
        self.symbol = crypto.symbol
        self.name = crypto.name
        self.image = crypto.image
        self.currentPrice = crypto.currentPrice
        self.marketCap = Int64(crypto.marketCap)
        self.marketCapRank = Int64(crypto.marketCapRank)
        self.fullyDilutedValuation = Int64(crypto.fullyDilutedValuation ?? 0)
        self.totalVolume = Int64(crypto.totalVolume)
        self.high24h = crypto.high24h
        self.low24h = crypto.low24h
        self.priceChange24h = crypto.priceChange24h
        self.priceChangePercentage24h = crypto.priceChangePercentage24h
        self.marketCapChange24h = Int64(crypto.marketCapChange24h)
        self.marketCapChangePercentage24h = crypto.marketCapChangePercentage24h
        self.circulatingSupply = crypto.circulatingSupply
        self.totalSupply = Double(crypto.totalSupply ?? 0)
        self.maxSupply = Double(crypto.maxSupply ?? 0)
        self.ath = crypto.ath ?? 0
        self.athChangePercentage = crypto.athChangePercentage
        self.atl = crypto.atl ?? 0
        self.atlChangePercentage = crypto.atlChangePercentage
        self.lastUpdated = crypto.lastUpdated
        
        do {
            let data = try crypto.sparklineIn7D.encodeToData()
            self.sparklineIn7D = data
        } catch {
            print("Error encoding sparkline data: \(error)")
        }
        
        // Note: `holdings` property is intentionally excluded from this update.
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
        entity.ath = ath ?? 0
        entity.athChangePercentage = athChangePercentage
        entity.atl = atl ?? 0
        entity.atlChangePercentage = atlChangePercentage
        entity.lastUpdated = lastUpdated
        entity.holdings = self.holdings
        do {
            let data = try sparklineIn7D.encodeToData()
            entity.sparklineIn7D = data  // Assuming 'sparklineData' is the attribute name in your Core Data model for binary data
        } catch {
            print("Error encoding sparkline data: \(error)")
        }
        
        return entity
    }
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "GBP"
        formatter.locale = Locale(identifier: "en_GB")
        
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 4
        
        return formatter
    }()
    
    static let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.positivePrefix = formatter.plusSign
        return formatter
    }()
    
    var formattedCurrentPrice: String {
        guard let formattedPrice = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: currentPrice)) else {
            return "£0.00"
        }
        return formattedPrice
    }
    
    var formattedCurrentPriceWithoutCurrency: String {
        guard let formattedPrice = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: currentPrice)) else {
            return "0.00"
        }
        // Assuming the formatter includes the pound sign, remove it.
        return formattedPrice.replacingOccurrences(of: "£", with: "")
    }
    
    
    var isPriceChangePositive: Bool {
        return priceChangePercentage24h >= 0
    }
    
    var formattedPriceChangePercentage: String {
        let percentageValue = priceChangePercentage24h / 100.0
        return Cryptocurrency.percentageFormatter.string(from: NSNumber(value: percentageValue)) ?? "0.00%"
    }
    
    var formattedMarketCap: String {
        guard let formattedMarketCap = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: Double(marketCap))) else {
            return "£0.00"
        }
        return formattedMarketCap
    }
    
    var formattedTotalVolume: String {
        guard let formattedTotalVolume = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: totalVolume)) else {
            return "£0.00"
        }
        return formattedTotalVolume
    }
    
    var formattedHigh24h: String {
        guard let formattedHigh24h = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: high24h)) else {
            return "£0.00"
        }
        return formattedHigh24h
    }
    
    var formattedLow24h: String {
        guard let formattedLow24h = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: low24h)) else {
            return "£0.00"
        }
        return formattedLow24h
    }
    
    var formattedAllTimeHigh: String {
        guard let formattedAth = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: ath ?? 0.00)) else {
            return "£0.00"
        }
        return formattedAth
    }
    
    var formattedAllTimeLow: String {
        guard let formattedAtl = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: atl ?? 0.00)) else {
            return "£0.00"
        }
        return formattedAtl
    }
    
    var formattedCirculatingSupply: String {
        guard let circulatingSupply = self.totalSupply else { return "N/A" }
        return circulatingSupply.formattedWithAbbreviations + " \(symbol.uppercased())"
    }
    
    var formattedTotalSupply: String {
        guard let totalSupply = self.totalSupply else { return "N/A" }
        return totalSupply.formattedWithAbbreviations + " \(symbol.uppercased())"
    }
    
    var formattedMaxSupply: String {
        guard let maxSupply = self.maxSupply else { return "N/A" }
        return maxSupply.formattedWithAbbreviations + " \(symbol.uppercased())"
    }
    
    var formattedHoldingsInGBP: String {
        let totalValue = holdings * currentPrice
        guard let formattedValue = Cryptocurrency.currencyFormatter.string(from: NSNumber(value: totalValue)) else {
            return "£0.00"
        }
        return formattedValue
    }
    
    var valueOfHoldings: Double {
        return holdings * currentPrice
    }
    
    
    
    func formattedHoldings(currentHoldings: Double) -> String {
        // Check if the holdings have decimal part or not
        let hasDecimal = currentHoldings.truncatingRemainder(dividingBy: 1) != 0
        
        // Formatter to handle the decimal part
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = hasDecimal ? 2 : 0 // Show 2 decimal places if there are decimals, otherwise show none
        formatter.maximumFractionDigits = 4 // Max of 4 decimal places
        
        guard let formattedHoldings = formatter.string(from: NSNumber(value: currentHoldings)) else {
            return "0 \(symbol.uppercased())" // Fallback in case of formatting failure
        }
        
        return "\(formattedHoldings) \(symbol.uppercased())"
    }
    
    
}


