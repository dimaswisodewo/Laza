//
//  UpdateCardViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 06/09/23.
//

import UIKit
import CreditCardForm
import Stripe

protocol UpdateCardViewControllerDelegate: AnyObject {
    
    func creditCardUpdated()
}

class UpdateCardViewController: UIViewController {
    static let identifier = "UpdateCardViewController"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    private let creditCardFormView: CreditCardFormView = {
        let card = CreditCardFormView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let creditCardTextField: STPPaymentCardTextField = {
        let textField = STPPaymentCardTextField()
        textField.postalCodeEntryEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let nameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        textField.setTitle(title: "Card Holder")
        textField.placeholder = "Card Holder..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let maxNameCount = 22
    
    private var isModelApplied = false
    
    private var viewModel: UpdateCardViewModel!
    
    weak var delegate: UpdateCardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        applyModel()
        registerEvents()
        setupCreditCard()
    }
    
    func configure(oldCard: CreditCardModel) {
        viewModel = UpdateCardViewModel(oldCard: oldCard)
    }
    
    private func applyModel() {
        guard let model = viewModel.oldCard else { return }
        nameTextField.text = model.owner
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.creditCardFormView.cardHolderString = model.owner
            self.paymentCardTextFieldDidChange(self.creditCardTextField)
        }
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func registerEvents() {
        creditCardTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(cardHolderTextFieldBeginEditing), for: .editingDidBegin)
        nameTextField.addTarget(self, action: #selector(cardHolderTextFieldEditingChange), for: .editingChanged)
    }
    
    private func setupConstraints() {
        view.addSubview(creditCardFormView)
        view.addSubview(nameTextField)
        view.addSubview(creditCardTextField)
        
        let inset: CGFloat = 20
        // Credit card form view
        NSLayoutConstraint.activate([
            creditCardFormView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            creditCardFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            creditCardFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            creditCardFormView.heightAnchor.constraint(equalTo: creditCardFormView.widthAnchor, multiplier: PaymentCardCollectionViewCell.heigthToWidthRatio)
        ])
        // Name text field
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: creditCardFormView.bottomAnchor, constant: 48),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            nameTextField.heightAnchor.constraint(equalToConstant: 60),
        ])
        // Credit card text field
        NSLayoutConstraint.activate([
            creditCardTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            creditCardTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            creditCardTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            creditCardTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupCreditCard() {
        // Set font
        creditCardFormView.cardNumberFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 18)
        creditCardFormView.cardPlaceholdersFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 10)
        creditCardFormView.cardTextFont = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 12)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func ctaButtonPressed() {
        
        if !nameTextField.hasText {
            SnackBarDanger.make(in: self.view, message: "Card owner cannot be empty",  duration: .lengthShort).show()
            return
        }
        
        guard let newCardNumber = creditCardTextField.cardNumber else {
            SnackBarDanger.make(in: self.view, message: "Card number cannot be empty",  duration: .lengthShort).show()
            return
        }
        
        if creditCardTextField.expirationMonth == 0 {
            SnackBarDanger.make(in: self.view, message: "Expiration month is not valid",  duration: .lengthShort).show()
            return
        }
        
        if creditCardTextField.expirationYear == 0 {
            SnackBarDanger.make(in: self.view, message: "Expiration year is not valid",  duration: .lengthShort).show()
            return
        }
        
        guard let cvc = creditCardTextField.cvc else {
            SnackBarDanger.make(in: self.view, message: "CVC cannot be empty", duration: .lengthShort).show()
            return
        }
        
        // Uncomment if want to enable card validation
//        if !creditCardTextField.isValid {
//            SnackBarDanger.make(in: self.view, message: "Card is not valid", duration: .lengthShort).show()
//            return
//        }
        
        guard let cardOwner = nameTextField.text else { return }
        
        viewModel.updateCard(
            cardOwner: cardOwner,
            newCardNumber: newCardNumber,
            expiredMonth: creditCardTextField.expirationMonth,
            expiredYear: creditCardTextField.expirationYear,
            cvv: cvc,
            completion: {
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                    self?.delegate?.creditCardUpdated()
                }
            }, onError: { errorMessage in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                }
            })
    }
    
    @objc private func cardHolderTextFieldBeginEditing() {
        creditCardFormView.paymentCardTextFieldDidEndEditingCVC()
    }
    
    @objc private func cardHolderTextFieldEditingChange() {
        guard var nameText = nameTextField.text else { return }
        if nameText.count >= maxNameCount {
            nameText.removeLast()
            nameTextField.text = nameText
        }
        creditCardFormView.cardHolderString = nameText
    }
}

// MARK: - STPPaymentCardTextField Delegate

extension UpdateCardViewController: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ creditCardTextField: STPPaymentCardTextField) {
        // Apply model at start
        if !isModelApplied {
            guard let model = viewModel.oldCard else { return }
            creditCardFormView.paymentCardTextFieldDidChange(
                cardNumber: model.cardNumber,
                expirationYear: UInt(model.expYear),
                expirationMonth: UInt(model.expMonth),
                cvc: model.cvc)
            isModelApplied = true
            return
        }
        
        creditCardFormView.paymentCardTextFieldDidChange(
            cardNumber: creditCardTextField.cardNumber,
            expirationYear: UInt(creditCardTextField.expirationYear),
            expirationMonth: UInt(creditCardTextField.expirationMonth),
            cvc: creditCardTextField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidEndEditingExpiration(
            expirationYear: UInt(creditCardTextField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardFormView.paymentCardTextFieldDidEndEditingCVC()
    }
}

