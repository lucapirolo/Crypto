//
//  TabBarItem.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI

enum TabBarItem: Hashable {
    case home, accounts, track, card
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .accounts: return "person.crop.circle"
        case .track: return "chart.line.uptrend.xyaxis"
        case .card: return "creditcard"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .accounts: return "Accounts"
        case .track: return "Track"
        case .card: return "Card"
        }
    }
    

}
