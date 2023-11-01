//
//  AddHoldingsSheetView.swift
//  Crypto
//
//  Created by Luca Pirolo on 31/10/2023.
//

import SwiftUI

struct AddHoldingsSheetView: View {
    let crypto: Cryptocurrency
    @ObservedObject var viewModel: CryptoDetailViewModel
    @State private var amountToAdd: String = ""
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode // Added to handle dismissal
    @State private var isUpdating = false
    @FocusState private var isInputFieldFocused: Bool
    
  
    
    var body: some View {
        ZStack {
            backgroundColor
            content
                .onAppear {
                    isInputFieldFocused = true // Request focus on the TextField when the view appears
                }
        }
    }

    private var backgroundColor: some View {
        Color.dynamicBackgroundColor(for: colorScheme)
            .edgesIgnoringSafeArea(.all)
    }

    private var content: some View {
        VStack {
            inputField
            Text("\(crypto.formattedCurrentPrice) per coin")
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            updateButton
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    private var inputField: some View {
        HStack {
            TextField("", text: Binding<String>(
                get: { self.amountToAdd },
                set: { self.handleInput($0) }
            ), prompt: Text("0 \(crypto.symbol.uppercased())").foregroundColor(.gray))
            .font(.largeTitle)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .keyboardType(.decimalPad)
            .background(Color.clear)
            .focused($isInputFieldFocused) // Bind the focus state to the TextField

            if !amountToAdd.isEmpty {
                Text(crypto.symbol.uppercased())
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
            }
        }
    }

    private var updateButton: some View {
        Button {
            isUpdating = true // Set updating status to true
            if let amount = Double(amountToAdd) {
                viewModel.addHoldings(cryptoId: crypto.id, amount)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    presentationMode.wrappedValue.dismiss() // Dismiss after a delay
                }
            }
        } label: {
            if isUpdating {
                Image(systemName: "checkmark") // SF Symbol for tick
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            } else {
                Text("Update Holding")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .tint(Color.lagoon)
        .buttonStyle(.bordered)
        .controlSize(.large)
    }

    // Function to handle and format the input
    private func handleInput(_ input: String) {
        var processed = input.filter { "0123456789.".contains($0) }
        let dotCount = processed.filter({ $0 == "." }).count
        if dotCount > 1 {
            let components = processed.components(separatedBy: ".")
            processed = components[0] + "." + components.dropFirst().joined()
        }
        self.amountToAdd = processed
    }
}
