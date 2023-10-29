//
//  UIKit.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//


import UIKit

extension UINavigationBar {
    static func configureCryptoNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Use dynamic color for the background
        if #available(iOS 13.0, *) {
            appearance.backgroundColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return .midnight // Your custom dark mode color
                default:
                    return .white // Color for light mode
                }
            }
        } else {
            // Fallback for older iOS versions
            appearance.backgroundColor = .white
        }

        // Dynamic color for title text attributes
        if #available(iOS 13.0, *) {
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor { traitCollection in
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        return UIColor.white // Color for dark mode
                    default:
                        return UIColor.midnight // Color for light mode
                    }
                },
                .font: UIFont(name: AcuminFontStyle.regular.rawValue, size: 18)!
            ]
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor { traitCollection in
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        return UIColor.white // Color for dark mode
                    default:
                        return UIColor.midnight // Color for light mode
                    }
                },
                .font: UIFont(name: AcuminFontStyle.regular.rawValue, size: 30)!
            ]
        } else {
            // Fallback for older iOS versions
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: AcuminFontStyle.regular.rawValue, size: 18)!
            ]
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: AcuminFontStyle.regular.rawValue, size: 30)!
            ]
        }

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}





