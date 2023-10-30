//
//  NumberExtensions.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.
//

import Foundation

extension Double {
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

    var formattedCurrency: String {
        guard let formattedPrice = Double.currencyFormatter.string(from: NSNumber(value: self)) else {
            return "£0.00"
        }
        return formattedPrice
    }
    
    var formattedCurrencyWithoutSymbol: String {
        guard let formattedPrice = Double.currencyFormatter.string(from: NSNumber(value: self)) else {
            return "0.00"
        }
        // Assuming the formatter includes the pound sign, remove it.
        return formattedPrice.replacingOccurrences(of: "£", with: "")
    }
    
    func formattedAsShort() -> String {
        if self.isNaN || self.isInfinite {
            return "N/A"
        }

        if self == 0 {
            return "∞"
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2

        let suffixes = ["", "K", "M", "B", "T"]
        let index = Int(log10(abs(self)) / 3.0)

        if index >= 1, index < suffixes.count {
            let newValue = self / pow(1000.0, Double(index))
            return "\(numberFormatter.string(from: NSNumber(value: newValue)) ?? "")\(suffixes[index])"
        } else {
            return numberFormatter.string(from: NSNumber(value: self)) ?? ""
        }
    }
    
    var formattedWithAbbreviations: String {
            let num = abs(self)
            let sign = (self < 0) ? "-" : ""

            switch num {
            case 1_000_000_000...:
                return "\(sign)\(String(format: "%.2f", self/1_000_000_000))B"
            case 1_000_000...:
                return "\(sign)\(String(format: "%.2f", self/1_000_000))M"
            case 1_000...:
                return "\(sign)\(String(format: "%.2f", self/1_000))K"
            default:
                return "\(self)"
            }
        }
}

extension Int {
    func formattedAsShort() -> String {
  
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        let suffixes = ["", "K", "M", "B", "T"]
        let index = Int(log10(Double(abs(self))) / 3.0)
        
        if index >= 1, index < suffixes.count {
            let newValue = Double(self) / pow(1000.0, Double(index))
            return "\(numberFormatter.string(from: NSNumber(value: newValue)) ?? "")\(suffixes[index])"
        } else {
            return numberFormatter.string(from: NSNumber(value: self)) ?? ""
        }
    }
}
