//
//  CartTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    
    func updateCartItems(productId: Int, sizeId: Int, indexPath: IndexPath, completion: @escaping (AddToCart) -> Void)
    
    func insertToCart(productId: Int, sizeId: Int, completion: @escaping (AddToCart) -> Void)
    
    func deleteCartItems(productId: Int, sizeId: Int, indexPath: IndexPath)
}

class CartTableViewCell: UITableViewCell {
    static let identifier = "CartTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    weak var delegate: CartTableViewCellDelegate?
    
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
    
    @IBOutlet weak var deleteButton: CircleButton! {
        didSet {
            deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        }
    }
    
    private var modelId: Int = -1
    private var sizeId: Int = -1
    private(set) var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure(model: CartItem, sizeId: Int) {
        modelId = model.id
        self.sizeId = sizeId
        productName.text = model.productName
        productPrice.text = "$\(model.price)".formatDecimal()
        productAmount.text = String(model.quantity)
        productImageView.image = nil
        productImageView.loadAndCache(url: model.imageUrl)
    }
    
    func setIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func configure(model: AddToCart) {
        productAmount.text = String(model.quantity)
    }
    
    @objc private func incrementButtonPressed() {
        delegate?.insertToCart(productId: modelId, sizeId: sizeId, completion: { addToCart in
            DispatchQueue.main.async { [weak self] in
                self?.configure(model: addToCart)
            }
        })
    }
    
    @objc private func decrementButtonPressed() {
        guard let indexPath = self.indexPath else {
            print("Index Path is nil")
            return
        }
        delegate?.updateCartItems(productId: modelId, sizeId: sizeId, indexPath: indexPath, completion: { addToCart in
            DispatchQueue.main.async { [weak self] in
                self?.configure(model: addToCart)
            }
        })
    }
    
    @objc private func deleteButtonPressed() {
        guard let indexPath = self.indexPath else {
            print("Index Path is nil")
            return
        }
        delegate?.deleteCartItems(productId: modelId, sizeId: sizeId, indexPath: indexPath)
    }
}
