//
//  ColorUtils.swift
//  Laza
//
//  Created by Dimas Wisodewo on 02/08/23.
//

import UIKit

enum CustomColor: String {
    case ButtonBG = "ButtonBG"
    case FBBlue = "FBBlue"
    case GoogleRed = "GoogleRed"
    case GreyLine = "GreyLine"
    case HomeBG = "HomeBG"
    case Orange = "Orange"
    case Purple = "Purple"
    case PurpleButton = "PurpleButton"
    case TextPrimary = "TextPrimary"
    case TextSecondary = "TextSecondary"
    case TwitterBlue = "TwitterBlue"
    case ViewBG = "ViewBG"
    case WhiteBG = "WhiteBG"
    case WhiteButtonPrimary = "WhiteButtonPrimary"
    case WhiteButtonSecondary = "WhiteButtonSecondary"
}

class ColorUtils {
    static let shared = ColorUtils()
    
    func getColor(color: CustomColor) -> UIColor? {
        return UIColor(named: color.rawValue)
    }
}

