//
//  PaymentFormTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import UIKit

class PaymentFormTableViewCell: UITableViewCell {

    static let identifier = "PaymentFormTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var cardOwnerField: CustomTextField! {
        didSet {
            cardOwnerField.setTitle(title: "Card Owner")
            cardOwnerField.autocorrectionType = .no
            cardOwnerField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var cardNumberField: CustomTextField! {
        didSet {
            cardNumberField.setTitle(title: "Card Number")
            cardNumberField.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var cardExpField: CustomTextField! {
        didSet {
            cardExpField.setTitle(title: "EXP")
            cardExpField.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var cardCvvField: CustomTextField! {
        didSet {
            cardCvvField.setTitle(title: "CVV")
            cardCvvField.autocorrectionType = .no
        }
    }
    
    func setPredefinedValue(cardOwner: String, cardNumber: String, exp: String, cvv: String) {
        
        cardOwnerField.text = cardOwner
        cardNumberField.text = cardNumber
        cardExpField.text = exp
        cardCvvField.text = cvv
        
        cardOwnerField.isEnabled = false
        cardNumberField.isEnabled = false
        cardExpField.isEnabled = false
        cardCvvField.isEnabled = false
    }
}
