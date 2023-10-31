// AccountsView.swift
// Crypto
// Created by Luca Pirolo on 30/10/2023.

import SwiftUI
import Charts

struct AccountsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var randomDouble: Double = 0
    @State private var isAmountHidden: Bool = false
    let crypto = Cryptos.placeholders[0]

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

    // Background view
    private var backgroundView: some View {
        Color.dynamicBackgroundColor(for: colorScheme)
            .edgesIgnoringSafeArea(.all)
    }

    // Main content view
    private var contentView: some View {
  
        VStack {
            balanceHeaderView
            balanceView
            iconsHStack
            VStack {
                HStack {
                    Text("Holdings")
                        .font(.system(size: 12, weight: .semibold))
                        .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.bottom, 4)
              
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(0..<10) { index in
                            cryptoRowView(crypto: Cryptos.placeholders[index % Cryptos.placeholders.count])
                        }
                    }
                    Spacer()
                        .frame(height: 50)
                }

            }
            .padding(.top)
            .padding(.horizontal)
            Spacer()
        }.padding(.top)
    }
    
    // Add this within your AccountsView struct
    private var iconsHStack: some View {
        HStack(alignment: .top, spacing: 25) {
            IconTextView(systemName: "wallet.pass", text: "Crypto Wallet")
            IconTextView(systemName: "dollarsign.arrow.circlepath", text: "Staking")
            IconTextView(systemName: "bitcoinsign", text: "Crypto Earn")
            IconTextView(systemName: "person.crop.artframe", text: "NFT")
        }
    }


    // Header view displaying the total balance title
    private var balanceHeaderView: some View {
        HStack {
            Text("Total Balance")
            eyeButton
        }
        .font(.system(size: 14, weight: .semibold))
        .textCase(.uppercase)
        .foregroundColor(.secondary)
    }

    // View displaying the balance amount
    private var balanceView: some View {
        HStack(spacing: 5) {
            SecondaryText(text: "£", fontSize: 24)
            balanceAmountView
            SecondaryText(text: " GBP", fontSize: 18)
        }
        .animation(.easeInOut, value: isAmountHidden)
    }

    // View for toggling visibility of the balance amount
    private var balanceAmountView: some View {
        Group {
            if isAmountHidden {
                PrimaryText(text: "**********", fontSize: 32)
            } else {
                PrimaryText(text: randomDouble.formattedCurrencyWithoutSymbol, fontSize: 32)
            }
        }
    }

    // Button to toggle the visibility of the balance amount
    private var eyeButton: some View {
        Button(action: toggleAmountVisibility) {
            Image(systemName: isAmountHidden ? "eye.slash" : "eye")
        }
    }

    // Toggles the visibility of the balance amount
    private func toggleAmountVisibility() {
        withAnimation(.easeInOut) {
            isAmountHidden.toggle()
        }
    }

    // Starts the process of updating the balance amount
    private func startUpdatingBalance() {
        generateRandomValue()
        startBalanceUpdateTimer()
    }

    // Starts a timer to update the balance amount periodically
    private func startBalanceUpdateTimer() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            generateRandomValue()
        }
    }

    // Generates a random balance amount
    private func generateRandomValue() {
        let value = Double.random(in: 165000...170000)
        randomDouble = round(value * 100) / 100
    }
    
    private func cryptoNameAndAmountView(crypto: Cryptocurrency) -> some View {
        VStack(alignment: .leading) {
            Text(crypto.name)
                .font(.system(size: 16, weight: .medium))

            Text("0.1000 BTC ($646.64)") // Replace with dynamic values if necessary
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
        }
    }

    private func cryptoPriceAndChangeView(crypto: Cryptocurrency) -> some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text(crypto.formattedCurrentPrice)
                .font(.system(size: 16, weight: .semibold))

            HStack {
                PriceChangeView(crypto: crypto)
                    .font(.caption)
            }
        }
    }

    private func cryptoRowView(crypto: Cryptocurrency) -> some View {
        HStack {
            CryptoImageView(imageURL: crypto.image)
            cryptoNameAndAmountView(crypto: crypto)
            Spacer()
            cryptoPriceAndChangeView(crypto: crypto)
        }
    }

}




// This can be moved to a separate file named IconTextView.swift
struct IconTextView: View {
    var systemName: String
    var text: String

    var body: some View {
        VStack{
            Image(systemName: systemName)
                .font(.system(size: 20))
                .frame(width: 30, height: 30)
                .padding()
                .background(Color(uiColor: .tertiarySystemGroupedBackground).opacity(0.8))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.5), lineWidth: 1.5)
                )
                .foregroundColor(.primary.opacity(0.8))
            
            Text(text)
                .font(.system(size: 8, weight: .semibold))
                .textCase(.uppercase)
                .foregroundColor(.secondary)
                .frame(width: 60)
                .multilineTextAlignment(.center)
        }
    }
}

// Preview provider
struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
