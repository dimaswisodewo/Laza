//
//  FontUtils.swift
//  Laza
//
//  Created by Dimas Wisodewo on 02/08/23.
//

import UIKit

enum CustomFont: String {
    case Inter = "Inter"
}

class FontUtils {
    static let shared = FontUtils()
    
    func getFont(font: CustomFont, weight: UIFont.Weight, size: CGFloat) -> UIFont {
        var fontName = font.rawValue
        switch weight {
        case .black:
            fontName += "-Black"
            break
        case .bold:
            fontName += "-Bold"
            break
        case .semibold:
            fontName += "-SemiBold"
            break
        case .light:
            fontName += "-Light"
            break
        case .medium:
            fontName += "-Medium"
            break
        case .regular:
            fontName += "-Regular"
            break
        default:
            break
        }
        guard let font = UIFont(name: fontName, size: size) else {
            print("Failed to get font: \(fontName)")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
