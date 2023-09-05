//
//  AddCardViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit
import CreditCardForm
import Stripe

protocol AddCardViewControllerDelegate: AnyObject {
    
    func newCreditCardAdded(newCreditCard: CreditCardModel)
}

class AddCardViewController: UIViewController {
    
    static let identifier = "AddCardViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
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
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    var onDismiss: (() -> Void)? // Present CartDetailViewController again after dismiss
    
    private let viewModel = AddCardViewModel()
    
    weak var delegate: AddCardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        setupConstraints()
        registerEvents()
        setupCreditCard()
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
        onDismiss?()
    }
    
    @objc private func ctaButtonPressed() {
        
        if !nameTextField.hasText {
            SnackBarDanger.make(in: self.view, message: "Card owner cannot be empty",  duration: .lengthShort).show()
            return
        }
        
        guard let cardNumber = creditCardTextField.cardNumber else {
            SnackBarDanger.make(in: self.view, message: "Card number cannot be empty",  duration: .lengthShort).show()
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
        
        viewModel.addCreditCard(
            cardOwner: cardOwner,
            cardNumber: cardNumber,
            expiredMonth: creditCardTextField.expirationMonth,
            expiredYear: creditCardTextField.expirationYear,
            cvv: cvc,
            completion: { newCreditCard in
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.newCreditCardAdded(newCreditCard: newCreditCard)
                    self?.navigationController?.popViewController(animated: true)
                }
            },
            onError: { errorMessage in
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

extension AddCardViewController: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ creditCardTextField: STPPaymentCardTextField) {
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
