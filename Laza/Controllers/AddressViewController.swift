//
//  AddressViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

class AddressViewController: UIViewController {

    static let identifier = "AddressViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var saveAddressButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var nameField: CustomTextField! {
        didSet {
            nameField.setTitle(title: "Name")
        }
    }
    
    @IBOutlet weak var countryField: CustomTextField! {
        didSet {
            countryField.setTitle(title: "Country")
        }
    }
    
    @IBOutlet weak var cityField: CustomTextField! {
        didSet {
            cityField.setTitle(title: "City")
        }
    }
    
    @IBOutlet weak var phoneField: CustomTextField! {
        didSet {
            phoneField.setTitle(title: "Phone Number")
        }
    }
    
    @IBOutlet weak var addressField: CustomTextField! {
        didSet {
            addressField.setTitle(title: "Address")
        }
    }
    
    
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
        onDismiss?()
    }

    @objc private func ctaButtonPressed() {
        
    }
}
