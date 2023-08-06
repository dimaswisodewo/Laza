//
//  AppSnackBar.swift
//  Laza
//
//  Created by Dimas Wisodewo on 06/08/23.
//

import UIKit
import SnackBar

class SnackBarDanger: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .red
        style.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 14)
        style.textColor = .white
        return style
    }
}

class SnackBarSuccess: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .systemGreen
        style.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 14)
        style.textColor = .white
        return style
    }
}
