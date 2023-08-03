//
//  BrandCollectionViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 27/07/23.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BrandCollectionViewCell"
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Brand name", for: .normal)
        button.titleLabel?.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 14)
        button.setTitleColor(ColorUtils.shared.getColor(color: .TextPrimary), for: .normal)
        button.backgroundColor = ColorUtils.shared.getColor(color: .ButtonBG)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) var category: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
        
        contentView.addSubview(button)
        
        setupConstraints()
        
        registerAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setTitle(title: String?) {
        button.setTitle(title, for: .normal)
        category = title
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func registerAction() {
        button.addTarget(self, action: #selector(brandButtonPressed), for: .touchUpInside)
    }
    
    @objc private func brandButtonPressed() {
        print("Brand button pressed: \(String(describing: category))")
    }
}
