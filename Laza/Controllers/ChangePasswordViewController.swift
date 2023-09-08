//
//  ChangePasswordViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 03/09/23.
//

import UIKit

protocol ChangePasswordViewControllerDelegate: AnyObject {
    
    func onPasswordUpdated()
}

class ChangePasswordViewController: UIViewController {

    static let identifier = "ChangePasswordViewController"
    
    private let viewModel = ChangePasswordViewModel()
    
    weak var delegate: ChangePasswordViewControllerDelegate?
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var oldPasswordField: CustomSecureTextField! {
        didSet {
            oldPasswordField.setTitle(title: "Old Password")
        }
    }
    
    @IBOutlet weak var newPasswordField: CustomSecureTextField! {
        didSet {
            newPasswordField.setTitle(title: "New Password")
        }
    }
    
    @IBOutlet weak var confirmPasswordField: CustomSecureTextField! {
        didSet {
            confirmPasswordField.setTitle(title: "Confirm Password")
        }
    }
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func ctaButtonPressed() {
        
        if !oldPasswordField.hasText {
            showSnackBarDanger(message: "Old password field cannot be emtpy")
            return
        }
        
        if !newPasswordField.hasText {
            showSnackBarDanger(message: "New password field cannot be emtpy")
            return
        }
        
        guard let newPassword = newPasswordField.text else { return }
        
        if !RegExManager.shared.isPasswordValid(passwordText: newPassword) {
            showSnackBarDanger(message: "Password min 8 characters, 1 letter, 1 number, & 1 special character")
            return
        }
        
        if newPassword != confirmPasswordField.text {
            showSnackBarDanger(message: "Password confirmation does not match")
            return
        }
        
        guard let oldPassword = oldPasswordField.text else { return }
        
        // Change password
        LoadingViewController.shared.startLoading(sourceVC: self)
        viewModel.changePassword(currentPassword: oldPassword, newPassword: newPassword, completion: {
            DispatchQueue.main.async { [weak self] in
                LoadingViewController.shared.stopLoading(completion: {
                    self?.navigationController?.popViewController(animated: true)
                    self?.delegate?.onPasswordUpdated()
                })
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                LoadingViewController.shared.stopLoading(completion: {
                    self?.showSnackBarDanger(message: errorMessage)
                })
            }
        })
    }
    
    private func showSnackBarDanger(message: String) {
        SnackBarDanger.make(in: self.view, message: message, duration: .lengthShort).show()
    }
}
