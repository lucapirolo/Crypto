//
//  AccountsView.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.
//

import SwiftUI
import Charts

struct AccountsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var randomDouble: Double = 0
    @State private var isAmountHidden: Bool = false
    
    let accountData = Account.createPlaceholderAccount()

    init() {
        UINavigationBar.configureCryptoNavBarAppearance()
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundView
                contentView
            }
            .navigationTitle("Accounts")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: startUpdatingBalance)
        }
    }

    private var backgroundView: some View {
        Color.dynamicBackgroundColor(for: colorScheme)
            .edgesIgnoringSafeArea(.all)
    }

    private var contentView: some View {
        VStack {
            Spacer()
            balanceHeaderView
            balanceView
            Spacer()
        }
    }

    private var balanceHeaderView: some View {
        HStack {
            Text("Total Balance")
            eyeButton
        }
        .font(.system(size: 14, weight: .semibold))
        .textCase(.uppercase)
        .foregroundColor(.secondary)
    }

    private var balanceView: some View {
        HStack(spacing: 5) {
            SecondaryText(text: "£", fontSize: 24)
            balanceAmountView
            SecondaryText(text: " GBP", fontSize: 18)
        }
        .animation(.easeInOut, value: isAmountHidden)
    }

    private var balanceAmountView: some View {
        if isAmountHidden {
            return PrimaryText(text: "**********", fontSize: 32)
        } else {
            return PrimaryText(text: randomDouble.formattedCurrencyWithoutSymbol, fontSize: 32)
        }
    }

    private var eyeButton: some View {
        Button(action: toggleAmountVisibility) {
            Image(systemName: isAmountHidden ? "eye.slash" : "eye")
        }
    }

    private func toggleAmountVisibility() {
        withAnimation(.easeInOut) {
            isAmountHidden.toggle()
        }
    }

    private func startUpdatingBalance() {
        generateRandomValue()
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            generateRandomValue()
        }
    }

    private func generateRandomValue() {
        // Generate a random value within the specified range
        let value = Double.random(in: 165000...170000)

        // Round the value to two decimal places
        randomDouble = round(value * 100) / 100
    }

}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
