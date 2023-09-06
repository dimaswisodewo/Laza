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
    
    func onSetSelectedCardOnSwipe(selectedIndex: Int)
}

class PaymentCardTableViewCell: UITableViewCell {
    static let identifier = "PaymentCardTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    private let inset: CGFloat = 20
    
    @IBOutlet weak var collectionView: DynamicHeightCollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
            collectionView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
            collectionView.register(PaymentCardCollectionViewCell.self, forCellWithReuseIdentifier: PaymentCardCollectionViewCell.identifier)
        }
    }
    
    var delegate: PaymentCardTableViewCellDelegate?
    
    private(set) var selectedViewIndex: Int = 0
    private var numberOfSavedCards: Int = 3
    private var cellWidth: CGFloat = 0
    
    func setNumberOfSavedCards(_ numberOfSavedCards: Int) {
        self.numberOfSavedCards = numberOfSavedCards
    }
    
    // Snap cell on finished swiping
    private func setSelectedCellOnEndSwipe(scrollViewOffset: CGFloat, cellWidth: CGFloat) {
        
        // Loop backward
        for cardIndex in stride(from: numberOfSavedCards-1, through: 0, by: -1) {
            let offsetMargin = CGFloat(cardIndex - 1) + 0.5
            if scrollViewOffset > cellWidth * offsetMargin {
                selectedViewIndex = cardIndex
                break
            }
        }
        
        collectionView.selectItem(
            at: IndexPath(item: selectedViewIndex, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally)
        
        // Set credit card text
        delegate?.onSetSelectedCardOnSwipe(selectedIndex: selectedViewIndex)
    }
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
    
    // Snap cell on will begin decelerating
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let itemWidth = collectionView.bounds.width - (CGFloat(2) * inset)
        let offset = scrollView.contentOffset.x
        setSelectedCellOnEndSwipe(scrollViewOffset: offset, cellWidth: itemWidth)
    }
    
    // Snap cell on will end dragging
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemWidth = collectionView.bounds.width - (CGFloat(2) * inset)
        let offset = scrollView.contentOffset.x
        setSelectedCellOnEndSwipe(scrollViewOffset: offset, cellWidth: itemWidth)
    }
}
