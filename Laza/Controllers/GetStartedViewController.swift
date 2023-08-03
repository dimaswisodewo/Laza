//
//  GetStartedViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class GetStartedViewController: UIViewController {
    
    static let identifier = "GetStartedViewController"
    
    @IBOutlet weak var fbButton: RoundedButton! {
        didSet {
            fbButton.layer.cornerRadius = 10
            fbButton.addTarget(self, action: #selector(fbButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var twitterButton: RoundedButton! {
        didSet {
            twitterButton.layer.cornerRadius = 10
            twitterButton.addTarget(self, action: #selector(twitterButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var googleButton: RoundedButton! {
        didSet {
            googleButton.layer.cornerRadius = 10
            googleButton.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
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
    
    @objc private func signUpButtonPressed() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: SignUpViewController.identifier) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func signInButtonPressed() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: LoginViewController.identifier) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func fbButtonPressed() {
        openSharedURL(appURL: "fb://", webURL: "https://facebook.com/")
    }
    
    @objc private func googleButtonPressed() {
        openSharedURL(appURL: "googlegmail://", webURL: "https://mail.google.com/")
    }
    
    @objc private func twitterButtonPressed() {
        openSharedURL(appURL: "twitter://", webURL: "https://twitter.com/")
    }
    
    private func openSharedURL(appURL: String, webURL: String) {
        guard let appURL = URL(string: appURL) else {
            print("Invalid URL: \(appURL)")
            return
        }
        let application = UIApplication.shared
    
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if app is not installed, open URL inside Safari
            guard let webURL = URL(string: webURL) else {
                print("Invalid URL: \(webURL)")
                return
            }
            application.open(webURL)
        }
    }
}
