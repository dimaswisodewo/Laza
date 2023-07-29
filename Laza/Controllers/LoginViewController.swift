//
//  LoginViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class LoginViewController: UIViewController {

    static let identifier = "LoginViewController"
    
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
    
    @IBOutlet weak var forgotPasswordButton: UIButton! {
        didSet {
            forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        }
    }
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func forgotPasswordButtonPressed() {
        print("Forgot password")
    }
    
    @objc private func loginButtonPressed() {
        
        guard let username = usernameTextField.text, !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Username is not valid")
            return
        }
        
        guard let password = passwordTextField.text, !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Password is not valid")
            return
        }
        
        viewModel.login(username: username, password: password) { loginToken in
            
            guard let loginToken = loginToken else {
                print("Login failed")
                return
            }
            
            print("Login success, Hello \(username)! token: \(loginToken.token)")
            
            // Move to Home Page
            DispatchQueue.main.async { [weak self] in
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier) as? MainTabBarViewController else { return }
                
                self?.view.window?.windowScene?.keyWindow?.rootViewController = vc
            }
        }
    }
}
