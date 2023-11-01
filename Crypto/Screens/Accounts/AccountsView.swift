// AccountsView.swift
// Crypto
// Created by Luca Pirolo on 30/10/2023.

import SwiftUI
import Charts

struct AccountsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isAmountHidden: Bool = false
    let crypto = Cryptos.placeholders[0]
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "holdings > 0")
    ) var cryptosWithHoldings: FetchedResults<CryptoCurrencyEntity>
    
    var portfolio: Cryptos {
        return cryptosWithHoldings.map{ $0.toModel() }.sortedByMostValuableHolding()
    }
    
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
            Divider()
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
                        ForEach(portfolio, id: \.id) { crypto in
                            NavigationLink(destination: CryptoDetailView(cryptos: portfolio, index: portfolio.lastIndex(of: crypto) ?? 0)) {
                                cryptoRowView(crypto: crypto)
                                
                            }
                            .buttonStyle(PlainButtonStyle())
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
                PrimaryText(text: portfolio.formattedSumOfHoldingsValue, fontSize: 32)
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
    
    
    private func cryptoNameAndAmountView(crypto: Cryptocurrency) -> some View {
        VStack(alignment: .leading) {
            Text(crypto.name)
                .font(.system(size: 16, weight: .medium))
            
            Text("\(crypto.formattedHoldings(currentHoldings: crypto.holdings)) (\(crypto.formattedHoldingsInGBP))") // Replace with dynamic values if necessary
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
        VStack {
            HStack {
                CryptoImageView(imageURL: crypto.image)
                cryptoNameAndAmountView(crypto: crypto)
                Spacer()
                cryptoPriceAndChangeView(crypto: crypto)
            }
            Divider()
        }
    }
    
}

// Preview provider
struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
