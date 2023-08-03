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
    
    func setTintColor(tintColor: UIColor?) {
        image.tintColor = tintColor
        title.textColor = tintColor
    }

    private func setupConstraints() {
        // Image
        NSLayoutConstraint.activate([
//            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
//            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            image.heightAnchor.constraint(equalToConstant: 24),
            image.widthAnchor.constraint(equalTo: image.heightAnchor),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        // Title
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
