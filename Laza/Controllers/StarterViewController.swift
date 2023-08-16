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
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        if /* DataPersistentManager.shared.isUserLoggedIn() */ false {
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
