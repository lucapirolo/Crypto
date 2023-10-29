// TabBarItemsPreferenceKey.swift
// Crypto
//
// Created by Luca Pirolo on 29/10/2023.

import SwiftUI

// MARK: - TabBarItemsPreferenceKey

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

// MARK: - TabBarItemViewModifier

struct TabBarItemViewModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}

// MARK: - TabBarItemViewModifierWithOnAppear

struct TabBarItemViewModifierWithOnAppear: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    @ViewBuilder func body(content: Content) -> some View {
        if selection == tab {
            content
                .opacity(1)
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
        } else {
            Text("")
                .opacity(0)
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
        }
    }
}

// MARK: - View Extension

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemViewModifierWithOnAppear(tab: tab, selection: selection))
    }
}
