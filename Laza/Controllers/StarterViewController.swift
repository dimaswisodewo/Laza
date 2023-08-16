//
//  StarterViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import UIKit

class StarterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var isExpired = true
        if let token = DataPersistentManager.shared.getTokenFromKeychain() {
            isExpired = SessionManager.shared.isSessionExpired(token: token)
        }
        print("Is token expired: \(isExpired)")
        
        if !isExpired {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier)
            view.window?.windowScene?.keyWindow?.rootViewController = vc
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: GetStartedViewController.identifier)
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: false)
            view.window?.windowScene?.keyWindow?.rootViewController = nav
        }
    }
}
