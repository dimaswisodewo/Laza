//
//  EditAddressViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/08/23.
//

import UIKit

class EditAddressViewController: UIViewController {

    static let identifier = "EditAddressViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPresssed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var nameField: CustomTextField! {
        didSet {
            nameField.autocorrectionType = .no
            nameField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var countryField: CustomTextField! {
        didSet {
            countryField.autocorrectionType = .no
            countryField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var cityField: CustomTextField! {
        didSet {
            cityField.autocorrectionType = .no
            cityField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var phoneField: CustomTextField! {
        didSet {
            phoneField.keyboardType = .numberPad
            phoneField.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var addressField: CustomTextField! {
        didSet {
            addressField.autocorrectionType = .no
            addressField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var isPrimarySwitch: UISwitch!
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    private var viewModel: EditAddressViewModel!
    private var address: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyModel()
    }
    
    func configure(address: Address) {
        self.address = address
        viewModel = EditAddressViewModel(addressId: address.id)
    }
    
    private func applyModel() {
        nameField.text = address?.receiverName
        countryField.text = address?.country
        cityField.text = address?.city
        phoneField.text = address?.phoneNumber
        isPrimarySwitch.isOn = address?.isPrimary ?? false
    }
    
    private func notifyObserver() {
        NotificationCenter.default.post(name: .addressUpdated, object: nil)
    }
    
    @objc private func backButtonPresssed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func ctaButtonPressed() {
        if !nameField.hasText {
            SnackBarDanger.make(in: self.view, message: "Name cannot be empty", duration: .lengthShort).show()
            return
        }
        
        if !countryField.hasText {
            SnackBarDanger.make(in: self.view, message: "Country cannot be empty", duration: .lengthShort).show()
            return
        }
        
        if !cityField.hasText {
            SnackBarDanger.make(in: self.view, message: "City cannot be empty", duration: .lengthShort).show()
            return
        }
        
        if !phoneField.hasText {
            SnackBarDanger.make(in: self.view, message: "Phone number cannot be empty", duration: .lengthShort).show()
            return
        }
        
        if !addressField.hasText {
            SnackBarDanger.make(in: self.view, message: "Address cannot be empty", duration: .lengthShort).show()
            return
        }
        
        guard let name = nameField.text else { return }
        guard let country = countryField.text else { return }
        guard let city = cityField.text else { return }
        guard let phone = phoneField.text else { return }
//        guard let address = addressField.text else { return }
        
        LoadingViewController.shared.startLoading(sourceVC: self)
        viewModel.updateAddress(
            country: country,
            city: city,
            receiverName: name,
            phone: phone,
            isPrimary: isPrimarySwitch.isOn,
            completion: { [weak self] in
                self?.notifyObserver()
                DispatchQueue.main.async {
                    LoadingViewController.shared.stopLoading(completion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            },
            onError: { errorMessage in
                DispatchQueue.main.async { [weak self] in
                    LoadingViewController.shared.stopLoading()
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                }
            })
    }
}
