//
//  AddressViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

protocol AddressViewControllerDelegate: AnyObject {
    
    func onNewAddressAdded(newAddress: Address)
}

class AddressViewController: UIViewController {

    static let identifier = "AddressViewController"
    
    weak var delegate: AddressViewControllerDelegate?
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var saveAddressButton: UIButton! {
        didSet {
            saveAddressButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var nameField: CustomTextField! {
        didSet {
            nameField.setTitle(title: "Name")
            nameField.autocorrectionType = .no
            nameField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var countryField: CustomTextField! {
        didSet {
            countryField.setTitle(title: "Country")
            countryField.autocorrectionType = .no
            countryField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var cityField: CustomTextField! {
        didSet {
            cityField.setTitle(title: "City")
            cityField.autocorrectionType = .no
            cityField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var phoneField: CustomTextField! {
        didSet {
            phoneField.setTitle(title: "Phone Number")
            nameField.autocorrectionType = .no
            phoneField.keyboardType = .phonePad
        }
    }
    
    @IBOutlet weak var addressField: CustomTextField! {
        didSet {
            addressField.setTitle(title: "Address")
            addressField.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var isPrimarySwitch: UISwitch!
    
    private let viewModel = AddressViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func notifyObserver() {
        NotificationCenter.default.post(name: .addressUpdated, object: nil)
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func backButtonPressed() {
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
        viewModel.addNewAddress(
            country: country,
            city: city,
            receiverName: name,
            phone: phone,
            isPrimary: isPrimarySwitch.isOn,
            completion: { [weak self] newAddress in
                self?.notifyObserver()
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.onNewAddressAdded(newAddress: newAddress)
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
