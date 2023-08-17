//
//  WalletTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import UIKit
import CreditCardForm

class WalletTableViewCell: UITableViewCell {
    static let identifier = "WalletTableViewCell"
    
    private let creditCard: CreditCardFormView = {
        let card = CreditCardFormView()
        card.cardNumberFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 18)
        card.cardPlaceholdersFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 10)
        card.cardTextFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 12)
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    func configure(model: CreditCardModel) {
        creditCard.cardHolderString = model.owner
        creditCard.paymentCardTextFieldDidChange(
            cardNumber: model.cardNumber,
            expirationYear: UInt(model.expYear),
            expirationMonth: UInt(model.expMonth),
            cvc: model.cvc ?? ""
        )
    }
    
    private func setupConstraints() {
        contentView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
        contentView.addSubview(creditCard)
        NSLayoutConstraint.activate([
            creditCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            creditCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            creditCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            creditCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
