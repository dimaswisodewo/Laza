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
            backButton.isHidden = true
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
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
    
    @objc private func signUpButtonPressed() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpViewController.identifier) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func forgotPasswordButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ForgotPasswordViewController.identifier)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginButtonPressed() {
        
        if !usernameTextField.hasText {
            SnackBarDanger.make(in: self.view, message: "Username is not valid", duration: .lengthShort).show()
            return
        }
        
        if !passwordTextField.hasText {
            SnackBarDanger.make(in: self.view, message: "Password is not valid", duration: .lengthShort).show()
            return
        }
        
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        LoadingViewController.shared.startLoading(sourceVC: self)
        
        viewModel.login(username: username, password: password, completion: { [weak self] loginUser in
            // Login success
            // Get profile
            self?.viewModel.getProfile(token: loginUser.accessToken, completion: { profile in
                // Get profile success
                DataPersistentManager.shared.addProfileToKeychain(profile: profile)
                SessionManager.shared.setCurrentProfile(profile: profile)
                DataPersistentManager.shared.addTokenToKeychain(token: loginUser.accessToken)
                DataPersistentManager.shared.addRefreshTokenToKeychain(token: loginUser.refreshToken)
                // Move to Home Page
                DispatchQueue.main.async {
                    LoadingViewController.shared.stopLoading()
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    guard let vc = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier) as? MainTabBarViewController else { return }
                    let nav = UINavigationController(rootViewController: vc)
                    nav.setNavigationBarHidden(true, animated: false)

                    self?.delegate = vc
                    self?.delegate?.onLoginSuccess()

                    self?.view.window?.windowScene?.keyWindow?.rootViewController = nav
                }
            }, onError: { errorMessage in
                // Get profile failed
                DispatchQueue.main.async { [weak self] in
                    LoadingViewController.shared.stopLoading()
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                }
            })
        }, onError: { errorMessage in
            // Login failed
            DispatchQueue.main.async {
                LoadingViewController.shared.stopLoading(completion: { [weak self] in
                    if errorMessage.contains("verify") { // Email has not been verified
                        self?.showAlertResendVerify()
                        return
                    }
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                })
            }
        })
    }
    
    private func showAlertResendVerify() {
            let alert = UIAlertController(title: "Email not verified", message: "Please verify your email", preferredStyle: .alert)

            // Alert action
            let alertAction = UIAlertAction(
                title: NSLocalizedString("OK", comment: "OK pressed"),
                style: .default) { [weak self] action in
                    // Go to verify email page
                    guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: ResendActivationViewController.identifier) else { return }
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            
            alert.addAction(alertAction)
            
            present(alert, animated: true, completion: nil)
        }
}
