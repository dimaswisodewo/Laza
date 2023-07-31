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
}

class ProductTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    
    weak var delegate: ProductTableViewCellDelegate?
    
    private let productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
            productCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func registerCollectionViewCell() {
//        print("register product collection view cell")
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
}

// MARK: - UICollectionView DataSource

extension ProductTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.productNumberOfItemsInSection(numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let delegate = delegate else {
            print("product delegate is nil")
            return UICollectionViewCell()
        }
        guard let cell = delegate.productCellForItemAt(cellForItemAt: indexPath) as? ProductCollectionViewCell else {
            print("Failed to get product collection view cell")
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension ProductTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numOfColum: CGFloat = 2.0
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = (layout.minimumInteritemSpacing * numOfColum) + collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right
        let width = (collectionView.frame.size.width / numOfColum ) - spacing
        let cellHeightToWidthAspectRatio = CGFloat(257.0 / 160)
        return CGSize(width: width, height: width * cellHeightToWidthAspectRatio)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//    }
}
