//
//  CustomSecureTextField.swift
//  Laza
//
//  Created by Dimas Wisodewo on 03/08/23.
//

import UIKit

class CustomSecureTextField: CustomTextField {

    private let secureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.imageView?.tintColor = ColorUtils.shared.getColor(color: .TextSecondary)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        registerActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        registerActions()
    }
    
    private func setupViews() {
        secureButton.frame = .init(x: 0, y: 0, width: super.frame.height, height: super.frame.height)
        super.isSecureTextEntry = true
        super.rightView = secureButton
        super.rightViewMode = .always
    }
    
    private func registerActions() {
        secureButton.addTarget(self, action: #selector(toggleSecure), for: .touchUpInside)
    }
    
    @objc private func toggleSecure() {
        isSecureTextEntry.toggle()
        secureButton.setImage(UIImage(systemName: isSecureTextEntry ? "eye" : "eye.slash"), for: .normal)
    }
}
