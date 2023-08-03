//
//  CustomTextField.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class CustomTextField: UITextField {

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 14)
        label.textColor = ColorUtils.shared.getColor(color: .TextSecondary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubview(titleLabel)
        
        setupConstraints()
        setupTextField()
    }
    
    func setTitle(title: String?) {
        titleLabel.text = title
    }
    
    private func setupTextField() {
        borderStyle = .none
        
        let line = UIView()
        line.isUserInteractionEnabled = false
        line.backgroundColor = ColorUtils.shared.getColor(color: .GreyLine)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(line)
        
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.topAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
