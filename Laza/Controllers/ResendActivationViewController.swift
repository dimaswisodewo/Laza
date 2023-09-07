//
//  ResendActivationViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/09/23.
//

import UIKit

class ResendActivationViewController: UIViewController {
    
    static let identifier = "ResendActivationViewController"

    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var emailField: CustomTextField! {
        didSet {
            emailField.setTitle(title: "Email Address")
            emailField.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    private let viewModel = ResendActivationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func showSnackBarDanger(message: String) {
        SnackBarDanger(contextView: self.view, message: message, duration: .lengthShort).show()
    }
    
    private func showSnackBarSuccess(message: String) {
        SnackBarSuccess(contextView: self.view, message: message, duration: .lengthShort).show()
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func ctaButtonPressed() {
        
        if !emailField.hasText {
            showSnackBarDanger(message: "Email cannot be empty")
            return
        }
        
        guard let email = emailField.text else { return }
        
        print("Resend")
        LoadingViewController.shared.startLoading(sourceVC: self)
        print("Loading active")
        viewModel.resendActivation(email: email, completion: {
            print("Success")
            DispatchQueue.main.async {
                LoadingViewController.shared.stopLoading(completion: { [weak self] in
                    self?.showSnackBarSuccess(message: "Activation link sent")
                })
            }
        }, onError: { errorMessage in
            print("Error: \(errorMessage)")
            DispatchQueue.main.async {
                LoadingViewController.shared.stopLoading(completion: { [weak self] in
                    self?.showSnackBarDanger(message: errorMessage)
                })
            }
        })
    }
}
