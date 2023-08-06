//
//  LoginViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    
    func onLoginSuccess()
}

class LoginViewController: UIViewController {

    static let identifier = "LoginViewController"
    
    weak var delegate: LoginViewControllerDelegate?
    
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
    
    @IBOutlet weak var passwordTextField: CustomTextField! {
        didSet {
            passwordTextField.setTitle(title: "Password")
            passwordTextField.autocorrectionType = .no
            passwordTextField.autocapitalizationType = .none
            passwordTextField.isSecureTextEntry = true
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
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func forgotPasswordButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ForgotPasswordViewController.identifier)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginButtonPressed() {
        
        guard let username = usernameTextField.text, !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SnackBarDanger.make(in: self.view, message: "Username is not valid", duration: .lengthShort).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SnackBarDanger.make(in: self.view, message: "Password is not valid", duration: .lengthShort).show()
            return
        }
        
        viewModel.login(username: username, password: password) { loginToken in
            
            guard let loginToken = loginToken else {
                SnackBarDanger.make(in: self.view, message: "Login failed", duration: .lengthShort).show()
                return
            }
            
            print("Login success, Hello \(username)! token: \(loginToken.token)")
            
            // Move to Home Page
            DispatchQueue.main.async { [weak self] in
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier) as? MainTabBarViewController else { return }
                let nav = UINavigationController(rootViewController: vc)
                nav.setNavigationBarHidden(true, animated: false)
                
                self?.delegate = vc
                self?.delegate?.onLoginSuccess()
                
                self?.view.window?.windowScene?.keyWindow?.rootViewController = nav
            }
        }
    }
}
