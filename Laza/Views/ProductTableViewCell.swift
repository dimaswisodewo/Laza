//
//  ProductTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 31/07/23.
//

import UIKit

protocol ProductTableViewCellDelegate: AnyObject {
    
    func productNumberOfItemsInSection(numberOfItemsInSection section: Int) -> Int
    
    func productCellForItemAt(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    func productDidSelectItemAt(didSelectItemAt indexPath: IndexPath)
}

class ProductTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    
    weak var delegate: ProductTableViewCellDelegate?
    
    private let productCollectionView: DynamicHeightCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "WhiteBG")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var collectionView: UICollectionView {
        return productCollectionView
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(productCollectionView)

        registerCollectionViewCell()

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        // Collection view
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func registerCollectionViewCell() {
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.bounces = false
        productCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension ProductTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.productNumberOfItemsInSection(numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate?.productCellForItemAt(cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.productDidSelectItemAt(didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numOfColum: CGFloat = 2.0
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = (layout.minimumInteritemSpacing * numOfColum) + collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right
        let width = (collectionView.frame.size.width / numOfColum ) - spacing
        let cellHeightToWidthAspectRatio = CGFloat(257.0 / 160)
        return CGSize(width: width, height: width * cellHeightToWidthAspectRatio)
    }
}
