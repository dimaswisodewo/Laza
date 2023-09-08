//
//  PaymentAddCardTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import UIKit

protocol PaymentAddCardTableViewCellDelegate: AnyObject {
    
    func updateCardButtonPressed()
    
    func deleteCardButtonPressed()
}

class PaymentAddCardTableViewCell: UITableViewCell {
    
    static let identifier = "PaymentAddCardTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    weak var delegate: PaymentAddCardTableViewCellDelegate?
    
    @IBOutlet weak var updateCardButton: RoundedButton! {
        didSet {
            updateCardButton.layer.borderWidth = 1
            updateCardButton.layer.borderColor = ColorUtils.shared.getColor(color: .TextPurple)?.cgColor
            updateCardButton.addTarget(self, action: #selector(updateCardButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var deleteCardButton: RoundedButton!  {
        didSet {
            deleteCardButton.layer.borderWidth = 1
            deleteCardButton.layer.borderColor = ColorUtils.shared.getColor(color: .TextRed)?.cgColor
            deleteCardButton.addTarget(self, action: #selector(deleteCardButtonPressed), for: .touchUpInside)
        }
    }
    
    func setEnableButtons(isEnable: Bool) {
        updateCardButton.isEnabled = isEnable
        deleteCardButton.isEnabled = isEnable
    }
    
    @objc private func updateCardButtonPressed() {
        delegate?.updateCardButtonPressed()
    }
    
    @objc private func deleteCardButtonPressed() {
        delegate?.deleteCardButtonPressed()
    }
}
