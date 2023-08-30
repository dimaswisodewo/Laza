//
//  ForgotPasswordViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    static let identifier = "ForgotPasswordViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var emailTextField: CustomTextField! {
        didSet {
            emailTextField.setTitle(title: "Email Address")
            emailTextField.autocorrectionType = .no
        }
    }
    
    private let viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonPressed() {
        
        if !emailTextField.hasText {
            SnackBarDanger.make(in: self.view, message: "Email address cannot be empty", duration: .lengthShort).show()
            return
        }
        
        guard let email = emailTextField.text else { return }
        
        if !RegExManager.shared.isEmailValid(emailText: email) {
            SnackBarDanger.make(in: self.view, message: "Email address is not valid", duration: .lengthShort).show()
            return
        }
        
        viewModel.forgotPassword(email: email, completion: {
            DispatchQueue.main.async { [weak self] in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc =  storyboard.instantiateViewController(withIdentifier: VerificationCodeViewController.identifier) as? VerificationCodeViewController else { return }
                vc.configure(emailAddress: email)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
    }
}
