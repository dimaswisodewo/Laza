//
//  RoundedButton.swift
//  Laza
//
//  Created by Dimas Wisodewo on 27/07/23.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {

    @IBInspectable public var cornerRadius: CGFloat = 10.0 {
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
        super.prepareForInterfaceBuilder()
        refreshBorder(_cornerRadius: cornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshBorder(_cornerRadius: cornerRadius)
    }
    
    private func refreshBorder(_cornerRadius: CGFloat) {
        self.layer.cornerRadius = _cornerRadius
    }
}
