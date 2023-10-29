//
//  View.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI

extension View {
    func showAlert(alert: Binding<AlertItem?>) -> some View {
        self.alert(item: alert) { alert in
            Alert(title: alert.title,
                  message: alert.message,
                  dismissButton: alert.dismissButton)
        }
    }
    
}