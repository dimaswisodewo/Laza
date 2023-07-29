//
//  GetStartedViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class GetStartedViewController: UIViewController {

    static let identifier = "GetStartedViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var fbButton: RoundedButton! {
        didSet {
            fbButton.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var twitterButton: RoundedButton! {
        didSet {
            twitterButton.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var googleButton: RoundedButton! {
        didSet {
            googleButton.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func signUpButtonPressed() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpViewController.identifier) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func signInButtonPressed() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: LoginViewController.identifier) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
