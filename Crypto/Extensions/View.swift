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
    
    func adaptiveBackgroundColor() -> some View {
        self.modifier(AdaptiveBackgroundColorModifier())
    }
    
    func buttonStyleProperties(isDisabled: Bool = false) -> some View {
        self
            .tint(Color.lagoon)
            .buttonStyle(.borderless)
            .controlSize(.large)
            .disabled(isDisabled)
    }
    
    func sectionHeaderStyle() -> some View {
        self
            .font(.system(size: 14, weight: .semibold))
            .textCase(.uppercase)
            .foregroundColor(.secondary)
    }
    
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .tint(Color.lagoon)
            .buttonStyle(.bordered)
            .controlSize(.large)
    }
}

struct AdaptiveBackgroundColorModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? Color.midnight : Color(uiColor: UIColor.systemBackground))
    }
}
