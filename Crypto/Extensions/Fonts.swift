//
//  Fonts.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import SwiftUI


extension Font {
    static func acumin(_ style: AcuminFontStyle, size: CGFloat) -> Font {
        return Font.custom(style.rawValue, size: size)
    }
}

//MARK: - Crypto.com SECONDARY TYPEFACE
enum AcuminFontStyle: String {
    case regular = "Acumin-RPro"
    case bold = "Acumin-BdPro"
    case italic = "Acumin-ItPro"
    case boldItalic = "Acumin-BdItPro"
}
