//
//  UpdatePasswordViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import UIKit

class UpdatePasswordViewController: UIViewController {
    
    static let identifier = "UpdatePasswordViewController"
    
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
           
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func resetPasswordButtonPressed() {
        
        guard let password = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        
        if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
        if confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
        
        if !RegExManager.shared.isPasswordValid(passwordText: password) {
            print("Password is not valid, minimum eight characters, at least one letter, one number, and one special character")
            return
        }
        
        if password != confirmPassword {
            print("Password confirmation does not match")
            return
        }
        
        viewModel.updatePassword(newPassword: password)
        print("Password updated")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
