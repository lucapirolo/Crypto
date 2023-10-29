//  CustomTabBarContainerView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.

import SwiftUI

/// A container view that manages a custom tab bar and the content associated with each tab.
struct CustomTabBarContainerView<Content: View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem]
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
        self._tabs = State(initialValue: [])
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { tabs = $0 }
    }
}

/// Preview provider for CustomTabBarContainerView
struct CustomTabBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(TabBarItem.home)) {
            Color.red
        }
    }
}
