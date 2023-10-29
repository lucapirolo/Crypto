//  Alert.swift
//  Crypto
//  Created by Luca Pirolo on 29/10/2023.

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

extension AlertItem {
    static func create(title: String, message: String, dismissText: String = "OK") -> AlertItem {
        return AlertItem(
            title: Text(NSLocalizedString(title, comment: "")),
            message: Text(NSLocalizedString(message, comment: "")),
            dismissButton: .default(Text(NSLocalizedString(dismissText, comment: "")))
        )
    }
}

struct AlertContext {
    // MARK: - NETWORK ALERTS
    static let invalidData = AlertItem.create(
        title: "Server Error",
        message: "The data received from the server was invalid. Please contact support"
    )

    static let invalidResponse = AlertItem.create(
        title: "Server Error",
        message: "Invalid response from the server. Please try again later."
    )

    static let invalidURL = AlertItem.create(
        title: "Server Error",
        message: "There was an issue connecting to the server. If this persists."
    )

    static let unableToComplete = AlertItem.create(
        title: "Server Error",
        message: "Unable to complete your request at this time. Please check your internet connection and try again."
    )

}
