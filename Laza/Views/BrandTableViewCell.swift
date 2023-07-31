//
//  BrandTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 31/07/23.
//

import UIKit

protocol BrandTableViewCellDelegate: AnyObject {
    
    func brandNumberOfItemsInSection(numberOfItemsInSection section: Int) -> Int
    
    func brandCellForItemAt(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class BrandTableViewCell: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    
    weak var delegate: BrandTableViewCellDelegate?
    
    private let brandCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var collectionView: UICollectionView { return brandCollectionView }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(brandCollectionView)

        registerCollectionViewCell()

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//        print("register brand collection view cell")
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
        guard let cell = delegate?.brandCellForItemAt(cellForItemAt: indexPath) else {
            print("Failed to get brand collection view cell")
            return UICollectionViewCell()
        }
        return cell
    }
}
