//
//  Colors.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import UIKit
import SwiftUI

struct BrandColors {
    static let admiral = "Admiral"
    static let anchor = "Anchor"
    static let lagoon = "Lagoon"
    static let midnight = "Midnight"
    static let slate = "Slate"
    static let fog = "Fog"
}

extension UIColor {
    // MARK: - Crypto.com Brand Colors

    static var admiral: UIColor { return color(named: BrandColors.admiral) }
    static var anchor: UIColor { return color(named: BrandColors.anchor) }
    static var lagoon: UIColor { return color(named: BrandColors.lagoon) }
    static var midnight: UIColor { return color(named: BrandColors.midnight) }
    static var slate: UIColor { return color(named: BrandColors.slate) }
    static var fog: UIColor { return color(named: BrandColors.fog) }

    // MARK: - Private Helper
    private static func color(named name: String) -> UIColor {
        return UIColor(named: name) ?? UIColor.clear
    }
}

extension Color {
    // MARK: - Crypto.com Brand Colors

    static var admiral: Color { return color(named: BrandColors.admiral) }
    static var anchor: Color { return color(named: BrandColors.anchor) }
    static var lagoon: Color { return color(named: BrandColors.lagoon) }
    static var midnight: Color { return color(named: BrandColors.midnight) }
    static var slate: Color { return color(named: BrandColors.slate) }
    static var fog: Color { return color(named: BrandColors.fog) }

    // MARK: - Private Helper
    private static func color(named name: String) -> Color {
        return Color(UIColor(named: name) ?? UIColor.clear)
    }
}
