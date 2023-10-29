//
//  SparklineTransformers.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import Foundation

import Foundation

class SparklineTransformer: ValueTransformer {
    // Converts SparklineIn7D object to Data
    override func transformedValue(_ value: Any?) -> Any? {
        guard let sparkline = value as? SparklineIn7D else { return nil }
        do {
            let data = try JSONEncoder().encode(sparkline)
            return data
        } catch {
            print("Error encoding SparklineIn7D: \(error)")
            return nil
        }
    }

    // Converts Data back to SparklineIn7D object
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let sparkline = try JSONDecoder().decode(SparklineIn7D.self, from: data)
            return sparkline
        } catch {
            print("Error decoding SparklineIn7D: \(error)")
            return nil
        }
    }
}
