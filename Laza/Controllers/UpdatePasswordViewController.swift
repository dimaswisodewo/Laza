//
//  UpdatePasswordViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import UIKit

protocol UpdatePasswordViewControllerDelegate: AnyObject {
    
    func onPasswordUpdated()
}

class UpdatePasswordViewController: UIViewController {
    
    static let identifier = "UpdatePasswordViewController"
    
    weak var delegate: UpdatePasswordViewControllerDelegate?
    
    @IBOutlet weak var passwordTextField: CustomSecureTextField! {
        didSet {
            passwordTextField.setTitle(title: "Password")
            passwordTextField.autocorrectionType = .no
            passwordTextField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var confirmPasswordTextField: CustomSecureTextField! {
        didSet {
            confirmPasswordTextField.setTitle(title: "Confirm Password")
            confirmPasswordTextField.autocorrectionType = .no
            confirmPasswordTextField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var resetPasswordButton: UIButton! {
        didSet {
            resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    private let viewModel = UpdatePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupDelegate() {
        guard let vc = tabBarController as? MainTabBarViewController else {
            print("Assign delegate failed")
            return
        }
        delegate = vc
    }
    
    @objc private func resetPasswordButtonPressed() {
        
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            SnackBarDanger.make(in: self.view, message: "Please fill out all required forms.", duration: .lengthShort).show()
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            SnackBarDanger.make(in: self.view, message: "Please fill out all required forms.", duration: .lengthShort).show()
            return
        }
        
        if !RegExManager.shared.isPasswordValid(passwordText: password) {
            SnackBarDanger.make(in: self.view, message: "Password min 8 characters, 1 letter, 1 number, & 1 special character.", duration: .lengthShort).show()
            return
        }
        
        if password != confirmPassword {
            SnackBarDanger.make(in: self.view, message: "Password confirmation does not match.", duration: .lengthShort).show()
            return
        }
        
        viewModel.updatePassword(newPassword: password)
        delegate?.onPasswordUpdated()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
