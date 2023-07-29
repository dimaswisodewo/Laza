//
//  RoundedImageView.swift
//  Laza
//
//  Created by Dimas Wisodewo on 27/07/23.
//

import UIKit

@IBDesignable class RoundedImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            refreshBorder(_cornerRadius: cornerRadius)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        refreshBorder(_cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        refreshBorder(_cornerRadius: cornerRadius)
    }
    
    override func prepareForInterfaceBuilder() {
        refreshBorder(_cornerRadius: cornerRadius)
    }
    
    private func refreshBorder(_cornerRadius: CGFloat) {
        self.layer.cornerRadius = _cornerRadius
    }

}
