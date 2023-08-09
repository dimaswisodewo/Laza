//
//  PaymentCardCollectionViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import UIKit
import Stripe
import CreditCardForm

class PaymentCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "PaymentCardCollectionViewCell"
    static var heigthToWidthRatio: CGFloat { 3 / 5 }
    
    private let creditCardFormView: CreditCardFormView = {
        let view = CreditCardFormView()
        view.cardNumberFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 18)
        view.cardPlaceholdersFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 10)
        view.cardTextFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(creditCardFormView)
        
        NSLayoutConstraint.activate([
            creditCardFormView.topAnchor.constraint(equalTo: contentView.topAnchor),
            creditCardFormView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            creditCardFormView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            creditCardFormView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configure(model: CreditCard) {
        creditCardFormView.cardHolderString = model.owner
        creditCardFormView.paymentCardTextFieldDidChange(
            cardNumber: model.cardNumber,
            expirationYear: UInt(model.expYear),
            expirationMonth: UInt(model.expMonth))
    }
}
