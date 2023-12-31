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

        tabBar.tintColor = ColorUtils.shared.getColor(color: .PurpleButton)
    }
}

// MARK: - LoginViewController Delegate

extension MainTabBarViewController: LoginViewControllerDelegate {
    
    func onLoginSuccess() {
        
        SnackBarSuccess.make(in: self.view, message: "Login success", duration: .lengthShort).show()
    }
}

// MARK: - UpdatePasswordViewController Delegate

extension MainTabBarViewController: UpdatePasswordViewControllerDelegate {
    
    func onPasswordUpdated() {
        
        SnackBarSuccess.make(in: self.view, message: "Password updated.", duration: .lengthShort).show()
    }
}
