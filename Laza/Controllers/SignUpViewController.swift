//
//  SignUpViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    
    func onSignUpSuccess()
}

class SignUpViewController: UIViewController {

    static let identifier = "SignUpViewController"
    
    weak var delegate: SignUpViewControllerDelegate?
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var usernameTextField: CustomTextField! {
        didSet {
            usernameTextField.setTitle(title: "Username")
            usernameTextField.autocorrectionType = .no
            usernameTextField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var passwordTextField: CustomSecureTextField! {
        didSet {
            passwordTextField.setTitle(title: "Password")
            passwordTextField.autocorrectionType = .no
            passwordTextField.autocapitalizationType = .none
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var emailTextField: CustomTextField! {
        didSet {
            emailTextField.setTitle(title: "Email Address")
            emailTextField.autocorrectionType = .no
            emailTextField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func signUpButtonPressed() {
        
        guard let email = emailTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            SnackBarDanger.make(in: self.view, message: "Username is not valid", duration: .lengthShort).show()
            return
        }
        if !RegExManager.shared.isPasswordValid(passwordText: password) {
            SnackBarDanger.make(in: self.view, message: "Password min 8 characters, 1 letter, 1 number, & 1 special character.", duration: .lengthShort).show()
            return
        }
        if !RegExManager.shared.isEmailValid(emailText: email) {
            SnackBarDanger.make(in: self.view, message: "Email is not valid", duration: .lengthShort).show()
            return
        }
        
        // Register
        LoadingViewController.shared.startLoading(sourceVC: self)
        viewModel.register(username: username, email: email, password: password, completion: { user in
            // Register success
            DispatchQueue.main.async { [weak self] in
                LoadingViewController.shared.stopLoading()
                self?.delegate?.onSignUpSuccess()
                self?.navigationController?.popViewController(animated: true)
            }
        }, onError: { errorMessage in
            // Register failed
            DispatchQueue.main.async {
                LoadingViewController.shared.stopLoading()
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
    }
    
}
