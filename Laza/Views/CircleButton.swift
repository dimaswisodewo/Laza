//
//  CircleButton.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

@IBDesignable class CircleButton: UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    private func sharedInit() {
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
