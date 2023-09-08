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
    
    private var viewModel: UpdatePasswordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    private func notifyObserver() {
        NotificationCenter.default.post(name: .passwordUpdated, object: nil)
    }
    
    func configure(emailAddress: String, code: String) {
        viewModel = UpdatePasswordViewModel(emailAddress: emailAddress, code: code)
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
        
        if !passwordTextField.hasText {
            SnackBarDanger.make(in: self.view, message: "Password cannot be empty", duration: .lengthShort).show()
            return
        }
        
        guard let password = passwordTextField.text else { return }
        
        if !RegExManager.shared.isPasswordValid(passwordText: password) {
            SnackBarDanger.make(in: self.view, message: "Password min 8 characters, 1 letter, 1 number, & 1 special character", duration: .lengthShort).show()
            return
        }

        if confirmPasswordTextField.text != password {
            SnackBarDanger.make(in: self.view, message: "Password confirmation does not match", duration: .lengthShort).show()
            return
        }
        
        LoadingViewController.shared.startLoading(sourceVC: self)
        viewModel.updatePassword(newPassword: password, completion: {
            DispatchQueue.main.async { [weak self] in
                LoadingViewController.shared.stopLoading(completion: {
                    self?.delegate?.onPasswordUpdated()
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.notifyObserver()
                })
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async {
                LoadingViewController.shared.stopLoading(completion: { [weak self] in
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                })
            }
        })
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
