//
//  ProductCollectionViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 28/07/23.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCollectionViewCell"
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let productName: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPrice: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var product: Product?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(image)
        contentView.addSubview(productName)
        contentView.addSubview(productPrice)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(product: Product) {
        self.product = product
        productName.text = product.name
        productPrice.text = "$\(product.price)".formatDecimal()
        image.loadAndCache(url: product.imageUrl)
    }
    
    private func setupConstraints() {
        // Image container view
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
        // Image view
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            image.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
        // Product name
        NSLayoutConstraint.activate([
            productName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productName.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 4)
        ])
        // Product price
        NSLayoutConstraint.activate([
            productPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 4),
            productPrice.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
