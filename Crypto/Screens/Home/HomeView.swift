//
//  HomeView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var tabSelection: TabBarItem = .track
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            TrackView()
                .tabBarItem(tab: .track, selection: $tabSelection)
            
            
            Text("Acounts")
                .tabBarItem(tab: .accounts, selection: $tabSelection)
            
        
            Text("Card")
                .tabBarItem(tab: .card, selection: $tabSelection)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

