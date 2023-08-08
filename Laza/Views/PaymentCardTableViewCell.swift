//
//  PaymentCardTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import UIKit

protocol PaymentCardTableViewCellDelegate {
    
    func collectionView(numberOfItemsInSection section: Int) -> Int
    
    func collectionView(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    func collectionView(collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class PaymentCardTableViewCell: UITableViewCell {
    static let identifier = "PaymentCardTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var collectionView: DynamicHeightCollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
            collectionView.register(PaymentCardCollectionViewCell.self, forCellWithReuseIdentifier: PaymentCardCollectionViewCell.identifier)
        }
    }
    
    var delegate: PaymentCardTableViewCellDelegate?
}

extension PaymentCardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate?.collectionView(numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        delegate?.collectionView(cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        delegate?.collectionView(collectionView: collectionView, sizeForItemAt: indexPath) ?? .zero
    }
}
