//
//  BrandTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 31/07/23.
//

import UIKit
import SkeletonView

protocol BrandTableViewCellDelegate: AnyObject {
    
    func brandNumberOfItemsInSection(numberOfItemsInSection section: Int) -> Int
    
    func brandCellForItemAt(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    func brandSizeForItemAt(sizeForItemAt indexPath: IndexPath) -> CGSize
}

class BrandTableViewCell: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    
    weak var delegate: BrandTableViewCellDelegate?
    
    private let brandCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var collectionView: UICollectionView { return brandCollectionView }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(brandCollectionView)

        registerCollectionViewCell()

        setupConstraints()
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSkeleton() {
        collectionView.isSkeletonable = true
    }
    
    private func showSkeleton() {
        collectionView.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeleton() {
        collectionView.hideSkeleton()
    }
    
    private func setupConstraints() {
        // Collection view
        NSLayoutConstraint.activate([
            brandCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            brandCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            brandCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            brandCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func registerCollectionViewCell() {
        brandCollectionView.dataSource = self
        brandCollectionView.delegate = self
        brandCollectionView.register(BrandCollectionViewCell.self, forCellWithReuseIdentifier: BrandCollectionViewCell.identifier)
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension BrandTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.brandNumberOfItemsInSection(numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate?.brandCellForItemAt(cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return delegate?.brandSizeForItemAt(sizeForItemAt: indexPath) ?? CGSize(width: 50, height: 50)
    }
}

// MARK: - SkeletonCollectionView DataSource

extension BrandTableViewCell: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        BrandCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath) as? BrandCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.showAnimatedGradientSkeleton()
        return cell
    }
}
