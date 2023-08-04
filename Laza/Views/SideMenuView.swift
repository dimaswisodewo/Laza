//
//  SideMenuView.swift
//  Laza
//
//  Created by Dimas Wisodewo on 04/08/23.
//

import UIKit

class SideMenuView: UIView {

    class var identifier: String { return String(describing: self) }
    
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = ColorUtils.shared.getColor(color: .TextPrimary)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 16)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        addSubview(image)
        addSubview(title)
        
        setupConstraints()
    }
    
    func configure(model: SideMenuModel) {
        image.image = model.icon
        title.text = model.title
    }
    
    func setTintColor(tintColor: UIColor?) {
        image.tintColor = tintColor
        title.textColor = tintColor
    }

    private func setupConstraints() {
        // Image
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            image.heightAnchor.constraint(equalToConstant: 24),
            image.widthAnchor.constraint(equalTo: image.heightAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        // Title
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
