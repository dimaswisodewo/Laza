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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonPressed() {
        guard let vc =  storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
