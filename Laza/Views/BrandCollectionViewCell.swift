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
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 17)
        button.setTitleColor(UIColor(named: "TextPrimary"), for: .normal)
        button.backgroundColor = UIColor(named: "ButtonBG")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(button)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setTitle(title: String?) {
        button.setTitle(title, for: .normal)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
