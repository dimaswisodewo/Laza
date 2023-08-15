//
//  CartTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    static let identifier = "CartTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var productImageView: UIImageView! {
        didSet {
            productImageView.contentMode = .scaleAspectFill
            productImageView.clipsToBounds = true
            productImageView.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productAmount: UILabel!
    
    @IBOutlet weak var decrementButton: CircleButton! {
        didSet {
            decrementButton.addTarget(self, action: #selector(decrementButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var incrementButton: CircleButton! {
        didSet {
            incrementButton.addTarget(self, action: #selector(incrementButtonPressed), for: .touchUpInside)
        }
    }
    
    private var productAmountCount: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure(model: Product) {
        productName.text = model.name
        productPrice.text = "$\(model.price)".formatDecimal()
        productImageView.loadAndCache(url: model.imageUrl)
    }
    
    private func refreshProductAmountLabel() {
        productAmount.text = String(productAmountCount)
    }
    
    @objc private func incrementButtonPressed() {
        productAmountCount += 1
        refreshProductAmountLabel()
    }
    
    @objc private func decrementButtonPressed() {
        if productAmountCount == 0 { return }
        productAmountCount -= 1
        refreshProductAmountLabel()
    }
}
