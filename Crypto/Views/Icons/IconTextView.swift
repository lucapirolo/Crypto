//
//  IconTextView.swift
//  Crypto
//
//  Created by Luca Pirolo on 01/11/2023.
//

import SwiftUI

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
