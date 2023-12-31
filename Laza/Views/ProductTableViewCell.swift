//
//  ProductTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 31/07/23.
//

import UIKit
import SkeletonView

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
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 32
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "WhiteBG")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSkeleton() {
        productCollectionView.isSkeletonable = true
    }
    
    func showSkeleton() {
        productCollectionView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        productCollectionView.hideSkeleton()
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
        collectionView.hideSkeleton()
        return delegate?.productCellForItemAt(cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.productDidSelectItemAt(didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset: CGFloat = 40 // EdgeInsets left & right of ProductCollectionView
        let numOfColum: CGFloat = 2.0
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = layout.minimumInteritemSpacing * (numOfColum - 1) + collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right + contentInset
        let width = (collectionView.frame.size.width / numOfColum ) - spacing
        let cellHeightToWidthAspectRatio = CGFloat(250) / CGFloat(160)
        return CGSize(width: width, height: width * cellHeightToWidthAspectRatio)
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension ProductTableViewCell: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return ProductCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.showSkeleton()
        return cell
    }
}
