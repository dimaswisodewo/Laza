//
//  SideMenuTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 30/07/23.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = UIColor(named: "TextPrimary")
        iv.layer.cornerRadius = iv.bounds.width / 2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textColor = UIColor(named: "TextPrimary")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        contentView.addSubview(image)
        contentView.addSubview(title)
        
        setupConstraints()
    }
    
    func configure(model: SideMenuModel) {
        image.image = model.icon
        title.text = model.title
    }

    private func setupConstraints() {
        // Image
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            image.widthAnchor.constraint(equalTo: image.heightAnchor),
        ])
        // Title
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
