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
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Wishlist"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let productName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Medium", size: 12)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-SemiBold", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(image)
        imageContainer.addSubview(heartButton)
        contentView.addSubview(productName)
        contentView.addSubview(productPrice)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(product: Product) {
        productName.text = product.title
        productPrice.text = String(product.price)
        image.loadAndCache(url: product.image)
    }
    
    private func setupConstraints() {
        // Image container view
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ])
        
        // Image view
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            image.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
        
        // Wishlist button
        NSLayoutConstraint.activate([
            heartButton.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 10),
            heartButton.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -10),
            heartButton.widthAnchor.constraint(equalToConstant: 20),
            heartButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Product name
        NSLayoutConstraint.activate([
            productName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productName.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 5)
        ])
        
        // Product price
        NSLayoutConstraint.activate([
            productPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 5),
            productPrice.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}
