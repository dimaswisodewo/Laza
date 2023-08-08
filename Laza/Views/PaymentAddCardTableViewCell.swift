//
//  PaymentAddCardTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import UIKit

protocol PaymentAddCardTableViewCellDelegate: AnyObject {
    
    func addNewCardButtonPressed()
}

class PaymentAddCardTableViewCell: UITableViewCell {
    
    static let identifier = "PaymentAddCardTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    weak var delegate: PaymentAddCardTableViewCellDelegate?
    
    @IBOutlet weak var addNewCardButton: RoundedButton! {
        didSet {
            addNewCardButton.layer.borderWidth = 1
            addNewCardButton.layer.borderColor = ColorUtils.shared.getColor(color: .TextPurple)?.cgColor
            addNewCardButton.addTarget(self, action: #selector(addNewCardButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc private func addNewCardButtonPressed() {
        delegate?.addNewCardButtonPressed()
    }
}
