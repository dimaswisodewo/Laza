//
//  MainTabBarViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    static let identifier = "MainTabBarViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor(named: "PurpleButton")
    }
}

// MARK: - LoginViewController Delegate

extension MainTabBarViewController: LoginViewControllerDelegate {
    
    func onLoginSuccess() {
        
        SnackBarSuccess.make(in: self.view, message: "Login success", duration: .lengthShort).show()
    }
}
