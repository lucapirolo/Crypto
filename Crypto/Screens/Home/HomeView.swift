//
//  HomeView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var tabSelection: TabBarItem = .track
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var trackViewModel = TrackViewModel()
    
    
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            TrackView(viewModel: trackViewModel)
                .tabBarItem(tab: .track, selection: $tabSelection)
            
            AccountsView()
                .tabBarItem(tab: .accounts, selection: $tabSelection)
        }
        .adaptiveBackgroundColor()
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

