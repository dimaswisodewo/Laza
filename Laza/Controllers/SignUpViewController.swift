//
//  SignUpViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class SignUpViewController: UIViewController {

    static let identifier = "SignUpViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var usernameTextField: CustomTextField! {
        didSet {
            usernameTextField.setTitle(title: "Username")
        }
    }
    
    @IBOutlet weak var passwordTextField: CustomTextField! {
        didSet {
            passwordTextField.setTitle(title: "Password")
        }
    }
    
    @IBOutlet weak var emailTextField: CustomTextField! {
        didSet {
            emailTextField.setTitle(title: "Email Address")
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        }
    }
    
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func signUpButtonPressed() {
        
        guard let email = emailTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("Username is not valid")
            return
        }
        if !RegExManager.shared.isPasswordValid(passwordText: password) {
            print("Password is not valid, minimum eight characters, at least one letter, one number, and one special character")
            return
        }
        if !RegExManager.shared.isEmailValid(emailText: email) {
            print("Email is not valid")
            return
        }
        
        var user = User()
        user.email = email
        user.username = username
        user.password = password
        viewModel.saveUserData(user: user, password: password)
        
        navigationController?.popViewController(animated: true)
    }
    
}
