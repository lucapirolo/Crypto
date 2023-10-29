//  CustomTabBarView.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - UI Constants
    private struct Constants {
        static let tabBarPadding: CGFloat = 6
        static let tabBarCornerRadius: CGFloat = 10
        static let tabBarShadowOpacity: Double = 0.3
        static let tabBarShadowRadius: CGFloat = 10
        static let tabBarShadowYOffset: CGFloat = 5
        static let tabItemVerticalPadding: CGFloat = 8
        static let tabItemFontSize: CGFloat = 12
        static let tabItemFontWeight: Font.Weight = .semibold
        static let tabItemCornerRadius: CGFloat = 10
        static let tabItemBackgroundOpacity: Double = 0.2
        static let horizontalPadding: CGFloat = 16
    }
    
    init(tabs: [TabBarItem], selection: Binding<TabBarItem>) {
        self.tabs = tabs
        self._selection = selection
        self._localSelection = State(initialValue: selection.wrappedValue)
    }
    
    var body: some View {
        tabBar
            .onChange(of: selection) { value in
                withAnimation(.easeInOut) {
                    localSelection = value
                }
            }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [.home, .accounts, .track, .card]
    
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!))
        }
    }
}

extension CustomTabBarView {
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.acumin(.regular, size: Constants.tabItemFontSize))
                .fontWeight(Constants.tabItemFontWeight)
        }
        .foregroundColor(localSelection == tab ? Color.lagoon : Color.gray)
        .padding(.vertical, Constants.tabItemVerticalPadding)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: Constants.tabItemCornerRadius)
                        .fill(Color.lagoon.opacity(Constants.tabItemBackgroundOpacity))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }
    
    private var tabBar: some View {
        
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchTo(tab: tab)
                    }
            }
        }
        .padding(Constants.tabBarPadding)
        .background(colorScheme == .dark ? Color.midnight : Color(uiColor: UIColor.systemGroupedBackground))
        .cornerRadius(Constants.tabBarCornerRadius)
        .shadow(color: Color.black.opacity(Constants.tabBarShadowOpacity), radius: Constants.tabBarShadowRadius, x: 0, y: Constants.tabBarShadowYOffset)
        .padding(.horizontal, Constants.horizontalPadding)
    }
    
    private func switchTo(tab: TabBarItem) {
        selection = tab
    }
}
